# AutocompleteRails

Easily set up Rails controller actions for use with jQuery UI's Autocomplete widget. `AutocompleteRails` is a very
lightweight component with easily understandable, and minimal, source code.

`AutocompleteRails` only supports ActiveRecord.



## Install

To get started, add the gem to your Rails app's `Gemfile`:

```ruby
gem 'autocomplete_rails'
```

And install the gem:

```sh
bundle install
```

You will also need to install jQuery UI, see (jquery-ui-rails)[https://github.com/joliss/jquery-ui-rails].


## Use

### Controller

Any controller needing an autocomplete action should invoke class method `autocomplete` with the model class and 
method to be autocompleted as arguments. An autocomplete method is generated. 

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

jQuery UI's autocomplete widget is flexible and well documented. Just set the widget's source property to the 
autocomplete rails controller path you wish to access. A common way to do this is by setting the path to
the autocomplete action in a data attribute of the input. For example:

Place the url in a data attribute of a text field tag:

```erb
<% form_tag articles_path do %>
    <%= text_field_tag :search, params[:search], data: { autocomplete: autocomplete_user_email_users_path }
<% end %>
```

Which creates an <input> tag that looks like this:

```html
<input name="search" type="text" data-autocomplete="users/autocomplete_user_email">
```


A simple jQuery event handler will attach autocomplete to any input[data-autocomplete]. Pass 
in your url as the source to jQuery's autocomplete widget. Here's an example that adds autocomplete
to the input field show above:

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

Autocomplete has a number of options.


## License

This project rocks and uses MIT-LICENSE.
