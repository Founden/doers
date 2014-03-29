DOERS by Geekcelerator
======================

[![Build Status](https://travis-ci.org/Founden/doers.svg?branch=master)](https://travis-ci.org/Founden/doers)

DOERS is a decision making and discussion tool. It was designed help
distributed teams make decision based on ideas exchange, discussions and
voting support.

![DOERS](http://img.svbtle.com/iuc2oy9j0r2oza.png)

[Read the full story](http://ampersate.com/the-last-7-months-of-our-venture).

## Installation

DOERS is written in Ruby using Rails and Ember.js.

You will need a PostgreSQL database, ideally with many connections allowed due
to websocket communication between the client and the server.

### Ruby version

We suggest using `rbenv` and `rbenv-install` in order to get Ruby install.

Install the latest stable Ruby version (MRI) available.

### Configuration

Make sure you create a copy of every file in the `config` folder with the
`.example` extension, leaving it out.

You can exclude: `aws.yml` and `bugsnag.yml`.
Those are using only in production.

2. Run `bundle install`
3. Run migrations `bundle exec rake db:create db:migrate db:test:prepare`
4. Run `rails s`
5. Open your browser and navigate to `http://lvh.me:3000` to login
6. Install some seed data `rake db:seed:development EMAIL=your@email`
7. Run `rails s` again

## Development

You can run `bundle exec rake db:create db:migrate`to set up the databse.

Run `bundle exec rails server` and point your browser to `http://lvh.me:3000`.

### Tests

Use RSpec to test models and controllers.
Use Capybara for integration testing.

Run `bundle exec rake` to run the tests.
You can also use Guard to run tests while writing them. Use `bundle exec guard`.

## Deployment

We use `mina` for deployments.

To deploy latest version from GitHub, run:

```bash
$ bundle exec mina deploy
```
