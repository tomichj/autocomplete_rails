require 'spec_helper'

describe 'search api' do
  before(:each) do
    @user1 = create(:user, :with_full_name)
    @user2 = create(:user, :with_full_name)
  end

  context 'empty search term' do
    before :each do
      do_get users_autocomplete_user_email_path,
             params: { term: '' }
    end

    it 'is successful' do
      # expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'returns no payload' do
      expect(json.size).to eq(0)
    end
  end
end
