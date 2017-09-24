class BlockUsersController < ApplicationController
  before_action :set_name

  autocomplete(:user, :email) { |r| if @name then r.where(last_name: @name) else r end }  

  def show
  end

  private
  
  def set_name
    if params[:name]
      @name = params[:name]
    end
  end
end
