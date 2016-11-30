#Somo

[![CircleCI](https://circleci.com/gh/uwblueprint/somo.svg?style=shield)](https://circleci.com/gh/uwblueprint/somo)
[![Code Climate](https://codeclimate.com/github/uwblueprint/somo/badges/gpa.svg)](https://codeclimate.com/github/uwblueprint/somo)
[![Test Coverage](https://codeclimate.com/github/uwblueprint/somo/badges/coverage.svg)](https://codeclimate.com/github/uwblueprint/somo/coverage)

## Development

Development is typically done on a local machine with local instances of various services (data stores, email sender, etc).

We are currently running on Ruby 2.3, Rails 4, and PostgreSQL 9.4. [Homebrew](http://mxcl.github.io/homebrew/) is recommended for installing dependencies.

### Set up Postgres

1. `brew install postgresql` or use [Postgres.app](http://postgresapp.com/)
2. A general `postgres` database user is recommended; CREATEDB and SUPERUSER privileges are required:
  
  ```
  $ createuser -s -d postgres # createuser is a command line tool installed with postgres
  ```
3. Start/manage the postgres service via:
  
  ```
  $ pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
  $ pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log status
  ```
  There are some settings to make it start by default as well.
  
`\q + ENTER` in terminal to quit interactive terminal


### Set up Rails
1. Install and manage Ruby versions with [rvm](http://rvm.io/). Make sure to install the correct Ruby version, which is specified in the [Gemfile]
2. `bundle install` to install dependencies
3. Create a file `config/secrets.yml`and add the following keys:
  ```
  development:
    secret_key_base: <your_secret_key>
    twilio_account_id: <twilio_account_id>
    twilio_auth_token: <twilio_auth_token>
    somo_phone_number: <somo_phone_number>
  ```
  Use `rake secret` to generate secret keys. Access the docs [here](https://docs.google.com/document/d/1X9D7-7yff8MpFdnh_rXd4MUGDJMFzJ8EbW6eJQNKz1Q/edit?usp=sharing) for API dev and test keys.
  
4. `rake db:create` to create the databases.

5. `rake db:migrate` to run migrations (creating the tables and their associations).

6. `rails server` and go to `localhost:3000`

7. Run `rspec` in the root directory to run the specs.

### Style Guide
1. Strings
  * Use single quotes instead of double quotes.
2. Hashes
  * Prefer `:` over `=>`.
3. Indentation
  * Use 2 spaces.
  * There should be no use of tabs.
4. Spacing
  * There should be no trailing whitespace.
  * There should be no empty new lines at the end of a file.
5. Line length
  * The maximum number of characters per line should be 100.
