# AutocompleteRails

Easily set up Rails controller actions for use with jQuery UI's Autocomplete widget.

Please use [GitHub Issues] to report bugs. You can contact me directly on twitter at
[@JustinTomich](https://twitter.com/justintomich).

`AutocompleteRails` is a lightweight component with easily understandable, minimal, source code. There are
other autocomplete gems out there that support multiple ORMs and provide client-side javascript, at the cost
of increased complexity. `AutocompleteRails` only supports ActiveRecord, and only provides rails 
controller functionality. Client side, you just use jQuery UI's autocomplete widget.

`AutocompleteRails` supports Rails 4 and Rails 5.

[![Gem Version](https://badge.fury.io/rb/autocomplete_rails.svg)](https://badge.fury.io/rb/autocomplete_rails) ![Build status](https://travis-ci.org/tomichj/autocomplete_rails.svg?branch=master)


## Install

To get started, add the gem to your Rails app's `Gemfile`:

```ruby
gem 'autocomplete_rails'
```

And install the gem:

```sh
bundle install
```

You will also need to install jQuery UI, see the [jquery-ui-rails](https://github.com/joliss/jquery-ui-rails) gem.


## Use

### Controller

Any controller needing an autocomplete action should invoke class method `autocomplete` with the model class and 
method to be autocompleted as arguments. An autocomplete method is generated. Then add a route leading to your 
generated method.

For example, to autocomplete users by email address in a Posts controller:

```ruby
class PostsController < ApplicationController
    autocomplete :user, :email
end
```

`autocomplete :user, :email` creates a method on `PostsController` named __autocomplete_user_email__.

Add a route to your autocomplete method. For the controller listed above, you might add:

```ruby
resources :posts do
  get :autocomplete_user_email, :on => :collection
end
```


### Wire up jQuery UI's autocomplete widget

jQuery UI's autocomplete widget is flexible and well documented. The most basic setup: just set the widget's 
`source` option to the autocomplete rails controller path you wish to access. A common way to do
this is by setting the path to the autocomplete action in a data attribute of the input, and access it from
coffeescript/javascript. For example:

Place the url in a data attribute of a text field tag:

```erb
<% form_tag articles_path do %>
    <%= text_field_tag :search, params[:search], data: { autocomplete: autocomplete_user_email_users_path }
<% end %>
```

Which creates an <input> tag that looks like this:

```html
<input name="search" type="text" data-autocomplete="/users/autocomplete_user_email">
```


A simple jQuery event handler will attach autocomplete to any input[data-autocomplete]. Pass 
in your `autocomplete` url as the source to jQuery's autocomplete widget. Here's an example (using turbolinks) 
that adds the `autocomplete` widget to the input field show above:

```coffeescript
$(document).on 'turbolinks:load', ->
  $("input[data-autocomplete]").each ->
    url = $(this).data('autocomplete')
    $(this).autocomplete
      source: url
```

You can read amore about jQuery UI's autocomplete here:

http://api.jqueryui.com/autocomplete/


## Advanced Usage

AutocompleteRails has a number of options, see [controller.rb](lib/autocomplete_rails/controller.rb).


## Credits & Thanks

This gem was inspired by, and draws heavily from:

* [autocomplete](https://github.com/voislavj/autocomplete)
* [rails3-jquery-autocomplete](https://github.com/crowdint/rails3-jquery-autocomplete)
* [rails4-autocomplete](https://github.com/peterwillcn/rails4-autocomplete)


## License

This project rocks and uses MIT-LICENSE.


[GitHub Issues]: https://github.com/tomichj/autocomplete_rails/issues
