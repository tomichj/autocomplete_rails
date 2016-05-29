require 'spec_helper'

describe UsersController, type: :controller do

  describe 'with two users in db' do
    before(:each) do
      @user1 = create(:user, :with_full_name)
      @user2 = create(:user, :with_full_name)
    end

    it { respond_to? :autocomplete_user_email }

    context 'empty search term' do
      before :each do
        get :autocomplete_user_email, term: ''
      end

      it 'is successful' do
        expect(response).to be_success
      end

      it 'returns no payload' do
        expect(json.size).to eq(0)
      end
    end

    context 'inclusive search term' do
      before :each do
        get :autocomplete_user_email, term: 'user'
      end

      it 'is successful' do
        expect(response).to be_success
      end

      it 'returns all users' do
        expect(json.size).to eq(2)
      end
    end

    context 'exclusive search term' do
      before :each do
        get :autocomplete_user_email, term: @user1.email
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

  describe 'with 20 users in db' do
    before(:each) do
      20.times { create(:user, :with_full_name) }
    end

    context 'inclusive search term' do
      before :each do
        get :autocomplete_user_email, term: 'user'
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
