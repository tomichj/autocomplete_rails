require 'spec_helper'

feature 'autocomplete', type: :feature do
  scenario 'with one result' do
    @user1 = create(:user, :with_full_name)
    visit '/users/autocomplete_user_email'
  end
end