# Shortr
Shorten URLs with gusto.

We basically have a simple form for the URL which, when submitted, checks that the URL is valid and if so, generates a unique slug using `:crypto.strong_rand_bytes` and stores this in our DB. Going to `<app_url>/<slug>` checks the DB to see if such a slug exists (we index by the slug in Postgres), and if so, increments the `hits` counter by one and redirects the user to the original URL.

Navigating to `/stats` allows us to see all of the shortened links and their corresponding hits. We're also able to export a CSV of this data from this page. The export is streamed into a chunked response to keep things speedy even as our dataset gets larger.

## 🧑‍💻 Development

### Requirements
- Postgres
- Elixir

### Setup
- If using ASDF, run `asdf install` to grab the correct versions of Elixir and Erlang.
- Install dependencies (`mix deps.get`)
- Create/migrate DB (`mix ecto.setup`)
- Start server (`iex -S mix phx.server`)
- Visit `localhost:4000`

### Testing
Run `mix test` and watch everything turn green :)