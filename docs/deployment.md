# Deployment (Uberspace via Capistrano)

## Prerequisites

- SSH access to the Uberspace server configured in `config/deploy.rb`
- Remote MySQL databases created (see step below)
- `.env` file present in the shared directory on the server

## 1. Create the production databases on the server

SSH into the server and run once per tournament:

```bash
mysql -e "CREATE DATABASE soemo_wm_2026_production CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -e "CREATE DATABASE soemo_beta_wm_2026_production CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

The database name is derived automatically by `capistrano-uberspace` as:
`soemo_<database_name_suffix>_production`

- Production (`tippspiel.rb`): `database_name_suffix = DEPLOYMENT_NAME` → `soemo_wm_2026_production`
- Beta (`beta-tippspiel.rb`): `database_name_suffix = "beta_#{DEPLOYMENT_NAME}"` → `soemo_beta_wm_2026_production`

`DEPLOYMENT_NAME` is set in `config/initializers/01_constants.rb`.

## 2. Update database.yml on the server

The server's `database.yml` lives in the Capistrano shared directory and is linked automatically.
Update it on the server before deploying:

```bash
vim <shared_path>/config/database.yml
```

The production entry should match the DB name above:

```yaml
production:
  adapter: mysql2
  encoding: utf8mb4
  collation: utf8mb4_unicode_ci
  database: soemo_wm_2026_production
  username: soemo
  password: <%= ENV['DB_PASSWORD'] %>
  host: localhost
```

## 3. Deploy

```bash
# production
bundle exec cap tippspiel deploy

# beta / staging
bundle exec cap beta-tippspiel deploy
```

Capistrano will:
1. Push the code
2. Run `bundle install`
3. Run `db:migrate`
4. Set the version + build date via `rake tippspiel:set_version`
5. Precompile assets
6. Restart Passenger

## 4. Seed production data

Run once after the first deploy of a new tournament:

```bash
bundle exec cap tippspiel db:run_seed
```

## 5. Smoke check

- Visit the site and confirm the tournament name displays correctly in both DE and EN
- Log in as admin, verify games are listed at `/admin/games`
- Trigger a test recalculation at `/admin/games` → click **Start Berechnung**
