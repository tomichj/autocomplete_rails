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

Once the gem is installed, there are 3 steps to set up an autocomplete:

* call `autocomplete` in your controller
* add a route to your newly generated autocomplete method
* provision an input in your UI with jQuery UI's autocomplete widget



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


### Routes

Add a route to your `autocomplete` action. For the controller listed above, you might add:

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


## Options

AutocompleteRails has a number of options, see [controller.rb](lib/autocomplete_rails/controller.rb).


### label_method

Call a separate method to generate the label in the response. If a `label_method` is not specified, it will
default to the `value_method`.

If your `label_method` is *not* a single column in your database but is reliant on multiple columns in your model,
you need to specify `full_model` (see below) to load all columns for your model.

Example:

```ruby
class PostsController < ApplicationController
    autocomplete :user, :email, label_method: :name
end
```


### full_model

Load the full model from the database. Default is `false`.

When `full_model` is `false`, only the `value_method` and `label_method` are selected from the database.

Example: your `label_method` is `first_and_last_name`, which is composed of multiple columns from your database. 
Load the full model to allow the method to be called:

```ruby
class PostsController < ApplicationController
    autocomplete :user, :email, label_method: :full_name, full_model: true
end
```


### limit

Limit the number of responses. The default limit is 10.

Example, setting the limit to 5:

```ruby
class PostsController < ApplicationController
    autocomplete :user, :email, limit: 5
end
```


### case_sensitive

If set to true, a case-sensitive search is performed. Defaults to false, performing a case-insensitive search. 

```ruby
class PostsController < ApplicationController
    autocomplete :user, :email, case_sensitive: true
end
```


### additional_data

Specify additional method called and returned in the response. Specify additional_data as an array.

If `additional_data` is specified and `full_model` is *not* specified, each additional_data column is added to
the columns selected.

```ruby
class PostsController < ApplicationController
    autocomplete :user, :email, additional_data: [:first_name, :last_name]
end
```


### scopes

Build your autocomplete query from the specified ActiveRecord scope(s). Multiple scopes can be used, 
pass them in as an array.

```ruby
class PostsController < ApplicationController
    autocomplete :user, :email, scopes: [:active_users]
end
```


### order

Specify a sort order. If none is specified, defaults to `'LOWER(#{table}.#{value_method}) ASC'`.


## Credits & Thanks

This gem was inspired by, and draws heavily from:

* [autocomplete](https://github.com/voislavj/autocomplete)
* [rails3-jquery-autocomplete](https://github.com/crowdint/rails3-jquery-autocomplete)
* [rails4-autocomplete](https://github.com/peterwillcn/rails4-autocomplete)


## License

This project rocks and uses MIT-LICENSE.


[GitHub Issues]: https://github.com/tomichj/autocomplete_rails/issues
