require 'spec_helper'
require 'support/request_helpers'

describe 'search api' do
  context 'with 2 users in database' do
    before(:each) do
      @user1 = create(:user, :with_full_name)
      @user2 = create(:user, :with_full_name)
    end

    context 'inclusive search term' do
      before :each do
        do_get users_autocomplete_user_email_path,
               params: { term: 'user' }
      end

      it 'is successful' do
        expect(response).to be_success
      end

      it 'returns all users' do
        expect(json.size).to eq(2)
      end
    end
  end

  context 'with 20 users in db' do
    before(:each) do
      20.times { create(:user, :with_full_name) }
    end

    context 'inclusive search term' do
      before :each do
        do_get users_autocomplete_user_email_path,
               params: { term: 'user' }
      end

      it 'is successful' do
        expect(response).to be_success
      end

      it 'returns default limit amount of users' do
        expect(json.size).to eq(10)
      end
    end
  end

end
