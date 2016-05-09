require 'spec_helper'

describe RailsAutocomplete::Controller do
  describe UsersController do

    it { respond_to? :autocomplete_user_email }

    context '3 users in db' do
      before :each do
        @user1 = create(:user, :with_full_name)
        create(:user, :with_full_name)
        create(:user, :with_full_name)
        get :autocomplete_user_email, search_term: 'user'
      end

      it { is_expected.to respond_with 200 }

      it 'returns 3 users' do
        json = JSON.parse(response.body)
        expect(json.size).to eq(3)
      end
    end
  end
end
