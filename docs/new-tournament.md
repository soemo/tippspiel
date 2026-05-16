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
tournament_name: "WC 2026"
```

## 2. Update seed data

Edit `db/seeds/wm2026.rb` (or create a new module e.g. `db/seeds/em2028.rb`):
- Update `game_data` with all fixtures (date, time in CEST, teams, round, group, place)
- Update `country_code_map` with all 48 (WM) or 24 (EM) teams using the flag sprite codes expected by the app (mostly ISO 3166-1 alpha-2, but keep custom values such as `_England`, `_Scotland`, `_Wales`, and `_Northern_Ireland` where required)
- Update `db/seeds.rb` to call the new module

## 3. Update database.yml

`config/database.yml` contains hardcoded database names that must be updated for each tournament.
The convention is `tippspiel_development_<deployment_name>`.

```yaml
development:
  database: tippspiel_development_wm_2026

test:
  database: tippspiel_test

# prod db == dev db — keep in sync with development
production:
  database: tippspiel_development_wm_2026
```

> The `test` database name stays constant — it is reset via schema load, not seeded.
> The `production` entry is only used when running locally against production data; the actual
> server has its own `database.yml` in the Capistrano shared directory (see [deployment.md](deployment.md)).

## 4. Set bonus question answers (after tournament)

Two of the four bonus questions (champion & second place) are answered automatically
from the final game result. The other two must be entered manually via the admin UI:

1. Go to `/admin/bonus_settings/new`
2. Enter the correct answers for:
   - **Question 3** — When did the first goal fall in the final?
   - **Question 4** — How many goals did the top scorer score?
3. Click **Bonusantworten speichern** — a flash message will confirm and remind you to run the calculation.
4. Go to `/admin/games` and click **Start Berechnung** to recalculate all user points.

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
