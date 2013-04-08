DOERS by Geekcelerator / doers.geekcelerator.com
================================================

For more details, checkout the [wiki](https://github.com/stas/doers/wiki)!

Below you can find some developer oriented docs to help you bring up the
environment and just hack around.

# Installation

1. Close the repository
2. Run `bundle install`
3. Run migrations `bundle exec rake db:create db:migrate db:test:prepare`
4. Install some seed data `rake db:seed:development`
5. Run `rails s`
6. Open your browser and navigate to `http://lvh.me:3000`

You are all set now! Use you local system username (ex.: `ENV['USER']`) or `dev`
and append `@lvh.me` to get the seeded user email account.
Your password is `secret` (the same for any pre-seeded user).

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
