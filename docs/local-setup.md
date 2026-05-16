# Local Development Setup

## Prerequisites

- [mise](https://mise.jdx.dev/) installed
- MySQL running locally (root access, no password by default)

## First-time setup

```bash
# Install Ruby (version from mise.toml / .ruby-version)
mise install

# Install gems
bundle install

# Create config/database.yml — set the development database name
# convention: tippspiel_development_wm_2026
# (see docs/new-tournament.md for the full template)

# Create a .env file with the following variables:
# SECRET_BASE_KEY=<rails secret>
# COOKIE_STORE_KEY=<random string>
# MAIL=<smtp config or "letter_opener">
# ADMIN_EMAIL=<your email>
# WEBSITE_URL=<e.g. http://localhost:3000>
```

## Create and seed the database

```bash
mise run db:create
mise run db:schema:load
mise run db:seed
```

## Setting up demo data for local development

`dev:prime` creates 100 demo users (`test1`–`test100`) with random tips on all games
and sets random goals. Tips are created immediately — no login required.

The simplest full setup after a fresh `db:reset + db:seed`:

```bash
mise run dev:setup
```

This runs `dev:prime` (creates users + random tips + random goals) followed by
`dev:finish-games-80` (marks 80 games finished and calculates rankings).

After running, log in as `test1@soemo.org` / `testtesttippspiel` and visit `/statistics`.

## Simulating finished games locally

The statistics page (ranking chart) only shows data once games are marked as finished
and rankings have been calculated. Use the `dev:finish-games` task to fake this locally.

```bash
# Mark the first N games as finished and recalculate rankings
mise run dev:finish-games 10    # after 10 games
mise run dev:finish-games 40    # halfway through group stage
mise run dev:finish-games 80    # 80 games

# Each call resets all games to unfinished first, so you can jump freely between any N.
```

## Common commands

| Command | Description |
|---|---|
| `mise run dev` | Start development server |
| `mise run test` | Run full test suite |
| `mise run console` | Rails console |
| `mise run db:seed` | Seed database |
| `mise run db:reset` | Drop, recreate and seed |
| `mise run db:migrate` | Run pending migrations |
| `mise run db:rollback` | Rollback last migration |
| `mise run dev:prime` | Create 100 demo users with random tips and random game goals |
| `mise run dev:finish-games N` | Mark first N games finished, recalculate rankings (e.g. `mise run dev:finish-games 20`) |
| `mise run dev:setup` | Full setup: prime users + finish 80 games (after db:reset + db:seed) |
| `mise exec -- rails db:schema:load RAILS_ENV=test` | Reset test database |
