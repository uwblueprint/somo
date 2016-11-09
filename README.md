#Somo

[![CircleCI](https://circleci.com/gh/uwblueprint/somo.svg?style=svg)](https://circleci.com/gh/uwblueprint/somo)

## Development

Development is typically done on a local machine with local instances of various services (data stores, email sender, etc).

We are currently running on Ruby 2.3, Rails 4, and PostgreSQL 9.4.


### Installing software on OS X

Install and manage Ruby versions with [rvm](http://rvm.io/). Make sure to install the correct Ruby version, which is specified in the [Gemfile]

[Homebrew](http://mxcl.github.io/homebrew/) is recommended for installing all other dependencies:

- `brew install postgresql` or use [Postgres.app](http://postgresapp.com/)

### Set up Rails

If it doesn't exist, create a file `configs/secrets.yml`and add the following keys:
```
development:
  secret_key_base: <your_secret_key>

```
Use `rake secret` to generate a secret keys.

### Set up Postgres

You should already have installed Postgres via the steps above.

A general `postgres` database user is recommended; CREATEDB and SUPERUSER privileges are required:

```
$ createuser -s -d postgres # createuser is a command line tool installed with postgres
```

Start/manage the postgres service via:

```
$ pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
$ pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log status
```

Start an interactive terminal via:

```
$ psql postgres # won't work until you migrate the database with the instructions below
```

Create the development and test databases:
```
create database somo_development;
create database somo_test;
```

`\q + ENTER` in terminal to quit interactive terminal
