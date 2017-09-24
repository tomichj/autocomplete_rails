class ScopedUsersController < ApplicationController
  autocomplete :user, :email, scopes: [[:has_lastname, 'MyScopeParam']]

  def show
  end
end
