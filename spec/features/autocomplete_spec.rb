require 'spec_helper'

feature 'autocomplete', type: :feature do
  scenario 'with one result' do
    create(:user, :with_full_name)
    visit '/users/autocomplete_user_email?term=use'
    # puts page.inspect
  end
end
