DOERS by Geekcelerator / doers.geekcelerator.com
================================================

For more details, checkout the [wiki](https://github.com/stas/doers/wiki)!

Below you can find some developer oriented docs to help you bring up the
environment and just hack around.

# Installation

Doers needs at least Ruby 2.0.0 and PostgreSQL 9.2.

To get the latest Ruby, consider using
[rbenv](http://rbenv.org) and
[ruby-build](https://github.com/sstephenson/ruby-build)

To get the PostgreSQL on mac consider using
[Postgres.app](http://postgresapp.com/) and on linux use the package manager
Ex.:

```bash
$ sudo apt-get install postgresql-9.2 postgresql-contrib-9.2
```

You will need to create two databases for the app `doers` and `doers_test`.

1. Close the repository
2. Run `bundle install`
3. Run migrations `bundle exec rake db:create db:migrate db:test:prepare`
4. Run `rails s`
5. Open your browser and navigate to `http://lvh.me:3000` to login
6. Install some seed data `rake db:seed:development EMAIL=your@email`
7. Run `rails s` again

Password is `secret` for any pre-seeded user.

# Deployments

DOERS uses a Heroku PostgreSQL database and is hosted on a Digital Ocean
instance. We use `mina` for deployments.

To deploy latest version from GitHub, run:

```bash
$ bundle exec mina deploy
```

# Coding style

## Vim

If you are using Vim, consider [my `.vimrc`](https://github.com/stas/dotfiles/blob/master/vimrc)

## Ruby

We pretty much follow [GitHub style](https://github.com/styleguide/ruby).
Please get some time reading what's there and setup your editor.

We use YARD for documentation instead of TomDoc. The simple rule is to have
at least one line that describes the module, class or method you wrote.

### Check your code before pushing!

Run quality assurance Rake task: `bundle exec rake qa`

## JavaScript

We pretty much follow [Idiomatic.js style](https://github.com/rwldrn/idiomatic.js).

Code style for indentation, white spaces and quotes from Ruby section is also
valid for JavaScript.
