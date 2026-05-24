# Deployment (Uberspace via Capistrano)

## Prerequisites

- SSH access to the Uberspace server configured in `config/deploy.rb`
- Remote MySQL databases created (see step below)
- `.env` file present in the shared directory on the server, including:
  - `FOOTBALL_DATA_API_TOKEN` — token from <https://www.football-data.org/client/register>, used by the admin-triggered result importer (button on `/admin/games`). Without it the import action surfaces a flash error and does nothing else.

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
  database: soemo_wm_2026_production
  username: soemo
  password: <%= ENV['DB_PASSWORD'] %>
  host: localhost
```

## 3. Deploy

Deployments are fully automated via GitHub Actions (`.github/workflows/continuous-deployment.yml`):

| Trigger | Target | Version |
|---|---|---|
| Merge to `main` | Beta (`beta-tippspiel.soemo.org`) | `<draft-release-version>-HH:MM` |
| Push a `v*` tag / publish a GitHub Release | Production (`tippspiel.soemo.org`) | tag name (strip leading `v`) |

**To deploy to production**, create and push a version tag:

```bash
git tag v1.2.3
git push origin v1.2.3
```

Or publish a GitHub Release with a `v*` tag — the workflow triggers on tag push either way.

The deploy action will:
1. Run the full test suite (must pass before deploy)
2. Run `bundle install` on the server
3. Run `db:migrate`
4. Set the version + build date
5. Precompile assets
6. Restart Passenger

## 4. Cron schedule (whenever)

The crontab is installed/updated **automatically on production deploys** by the Capistrano recipe in `config/deploy/recipes/own_deploy.rb`. The recipe skips beta deploys. No manual step needed.

The schedule (`config/schedule.rb`) runs `results:import_finished` every 15 min during 16:00–23:59 and 00:00–06:59 (Europe/Berlin), plus a daily safety run at 08:00. Normal output goes through `Rails.logger` to `log/production.log`; unexpected stderr (e.g. bundler errors) is also redirected there.

To inspect the live crontab on the server:
```bash
crontab -l
```

To remove the entries (e.g. end of tournament):
```bash
cd /var/www/virtual/soemo/tippspiel.soemo.org/current
bundle exec whenever --clear-crontab tippspiel.soemo.org
```

## 5. Seed data

Run once after the first deploy of a new tournament. **Do not run from your local machine via Capistrano** — run directly on the server:

```bash
# SSH into the server first
ssh soemo@farbauti.uberspace.de

cd /var/www/virtual/soemo/tippspiel.soemo.org/current        # production
# or
cd /var/www/virtual/soemo/beta-tippspiel.soemo.org/current   # beta

RAILS_ENV=production bundle exec rails db:seed
```

## 6. Redis (ranking cache)

The app uses Redis as the Rails cache store to cache the ranking computation across requests. Redis is not running by default on Uberspace — set it up once per account:

Follow the guide at <https://lab.uberspace.de/guide_redis/>, then add these to each app's shared `.env` file:

```
REDIS_URL=unix:///home/soemo/.redis/sock
REDIS_CACHE_NAMESPACE=tippspiel        # use "beta-tippspiel" for the beta app
```

Both apps share the same Redis instance on Uberspace, so the namespace keeps their caches isolated.

Without Redis running the app falls back gracefully to computing the ranking on every request (same behaviour as before). Redis errors are logged to `log/production.log` and never surfaced to the user.

## 7. Smoke check

- Visit the site and confirm the tournament name displays correctly in both DE and EN
- Log in as admin, verify games are listed at `/admin/games`
- Trigger a test recalculation at `/admin/games` → click **Start Berechnung**
- Confirm **Ergebnisse importieren** is visible at `/admin/games` and that `FOOTBALL_DATA_API_TOKEN` is set (clicking the button without a token must show the "Kein API-Token konfiguriert" flash, never crash)
