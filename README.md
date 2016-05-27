# AutocompleteRails




## Wiring up jQuery UI's autocomplete widget

jQuery UI's autocomplete widget is flexible and well documented. Just set the widget's source property to the 
autocomplete rails controller path you wish to access.

Place the url in a data attribute of a text field tag:

```erb
<% form_tag articles_path do %>
    <%= text_field_tag :search, params[:search], data: { autocomplete: autocomplete_user_email_users_path }
<% end %>
```


Which creates a tag that looks like this:

```html
<input name="search" type="text" data-autocomplete="users/autocomplete_user_email">
```


A simple jQuery event handler will attach autocomplete to your input, using your controller method:

```coffeescript
$(document).on 'turbolinks:load', ->
  $("input[data-autocomplete]").each ->
    url = $(this).data('autocomplete')
    $(this).autocomplete source: url
```


You can read amore about jQuery UI's autocomplete here:

http://api.jqueryui.com/autocomplete/



## License

This project rocks and uses MIT-LICENSE.
