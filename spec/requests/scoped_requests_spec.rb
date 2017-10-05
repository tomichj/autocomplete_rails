require 'spec_helper'
require 'support/request_helpers'

describe 'scopes' do
  context 'with 2 users in database' do
    before(:each) do
      @user1 = create(:user, :with_full_name, last_name: 'MyScopeParam')
      @user2 = create(:user, :with_full_name)
    end

    context 'scope with argument' do
      before :each do
        do_get scoped_users_autocomplete_user_email_path,
               params: { term: 'user' }
      end

      it 'is successful' do
        expect(response).to be_success
      end

      it 'returns only first user' do
        expect(json.size).to eq(1)
      end
    end
  end
end
