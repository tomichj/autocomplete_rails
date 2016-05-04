require 'spec_helper'

describe RailsAutocomplete::Controller do
  describe UsersController do
    before :each do
      create(:user, :with_full_name)
      create(:user, :with_full_name)
      create(:user, :with_full_name)
    end

    it { respond_to? :autocomplete_user_email }

    it 'does a get' do
      get :autocomplete_user_email, search_term: 'user'
      puts response.body
    end


    it 'has autocomplete method' do
      # subject.autocomplete_user_email
    end


    # it 'has autocomplete route' do
    #   # get :autocomplete_user_email
    # end
    #
    # it 'gug' do
    #   puts subject.controller_name
    #   puts subject.controller_path
    # end
  end
end
