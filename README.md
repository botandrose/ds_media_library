# DSMediaLibrary
[![Build Status](https://travis-ci.org/botandrose/ds_media_library.svg?branch=master)](https://travis-ci.org/botandrose/ds_media_library)

A reusable Media Library for Downstream projects built as a Rails Engine.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ds_media_library'
```

And then execute:

    $ bundle

## Usage

1. Mount the engine at the path of your choosing in your routes:
```ruby
# config/routes.rb
Rails.application.routes.draw do
  # ...
  mount DSMediaLibrary::Engine => "/media_library"
end
```

2. Require the app's JavaScript and CSS assets:
```sass
// application.sass
@import ds_media_library
```
```coffeescript
# application.coffee
#= require ds_media_library
```

3. Add ds_node columns to your models:
```ruby
# app/models/widget.rb
class Widget < ActiveRecord::Base
  ds_resource :cat_picture
  belongs_to_many_ds_resources :dog_pictures
end
```

4. Install and run the migrations
```
rails ds_media_library:install:migrations
rails db:migrate
```

5. Use the `#media_library` form helper where you would normally use the `#file_field` form helper:
```slim
/ app/views/widgets/form.html.slim
= form_for @widget do |form|
  = form.label :cat_picture
  = form.media_library :cat_picture

  = form.label :dog_pictures
  = form.media_library :dog_pictures, multiple: true
```

6. Profit!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake` to run the tests.

You can also run `bin/server` to start a dummy app at http://localhost:3000 that will allow you to experiment. Note that the state of the app is destroyed on exit.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org). You can then run `bundle update ds_media_library` in projects that use it to update them to the newly-released version.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/botandrose/ds_media_library.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

