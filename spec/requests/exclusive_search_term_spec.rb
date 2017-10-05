require 'spec_helper'
require 'support/request_helpers'

describe 'search api' do
  before(:each) do
    @user1 = create(:user, :with_full_name)
    @user2 = create(:user, :with_full_name)
  end

  context 'exclusive search term' do
    before :each do
      do_get users_autocomplete_user_email_path,
             params: { term: @user1.email }
    end

    it 'is successful' do
      expect(response).to be_success
    end

    it 'returns user' do
      expect(json.size).to eq(1)
    end

    it 'has label equal to email' do
      expect(json[0]['label']).to eq(@user1.email)
    end

    it 'has value equal to email' do
      expect(json[0]['value']).to eq(@user1.email)
    end
  end
end
