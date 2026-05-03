# Setting Up a New Tournament

Follow these steps whenever a new tournament starts (e.g. WM 2026, EM 2028).

## 1. Update constants

Edit `config/initializers/01_constants.rb`:

```ruby
DEPLOYMENT_NAME = 'wm_2026'   # used for DB name suffix in deployment
IS_WM = true                   # or false for EM
```

Edit `config/locales/de.yml` and `config/locales/en.yml`:

```yaml
# de.yml
tournament_name: "WM 2026"

# en.yml
tournament_name: "World Cup 2026"
```

## 2. Update seed data

Edit `db/seeds/wm2026.rb` (or create a new module e.g. `db/seeds/em2028.rb`):
- Update `game_data` with all fixtures (date, time in CEST, teams, round, group, place)
- Update `country_code_map` with all 48 (WM) or 24 (EM) teams and their ISO country codes
- Update `db/seeds.rb` to call the new module

## 3. Update database.yml

Set the development database name in `config/database.yml`:

```yaml
development:
  database: tippspiel_development_wm_2026
```

## 4. Set bonus question answers (after tournament)

Set answers in `config/initializers/01_constants.rb`:

```ruby
BONUS_ANSWER_HOW_MANY_GOALS = 142
BONUS_ANSWER_WHEN_WILL_THE_FIRST_GOAL = 1  # key from BONUS_OPTIONS_WHEN_WILL_THE_FIRST_GOAL
```

Then trigger recalculation at `/admin/start_calculating/new`.

## 5. Full checklist

- [ ] `DEPLOYMENT_NAME` updated
- [ ] `IS_WM` / `IS_EM` correct
- [ ] `tournament_name` in `de.yml` and `en.yml`
- [ ] Seed data updated (teams + fixtures)
- [ ] `database.yml` updated locally
- [ ] Local DB recreated and seeded (`mise run db:reset`)
- [ ] Full test suite passing (`mise run test`)
- [ ] Production DB created on server
- [ ] Server `database.yml` updated
- [ ] Deployed and seeded (`cap tippspiel deploy` + `cap tippspiel db:run_seed`)
- [ ] Smoke check passed
