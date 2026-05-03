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

# Optional: load 100 demo users with random tips (development only)
mise exec -- rails dev:prime
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
| `mise exec -- rails dev:prime` | Load 100 demo users with random tips |
| `mise exec -- rails db:schema:load RAILS_ENV=test` | Reset test database |
