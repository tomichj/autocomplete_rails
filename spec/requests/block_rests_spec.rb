require 'spec_helper'
require 'support/request_helpers'

describe 'blocks' do
  context 'with 2 users in database' do
    before(:each) do
      @user1 = create(:user, :with_full_name, last_name: 'MyBlockParam')
      @user2 = create(:user, :with_full_name)
    end

    context 'scope with argument' do
      before :each do
        do_get block_users_autocomplete_user_email_path(name: 'MyBlockParam'),
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
