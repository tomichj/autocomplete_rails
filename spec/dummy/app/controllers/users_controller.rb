class UsersController < ApplicationController
  autocomplete :user, :email

  def show
  end
end
