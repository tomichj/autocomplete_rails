require 'spec_helper'

describe RailsAutocomplete::Controller do
  before do
    class FakesController < ApplicationController
      include RailsAutocomplete::Controller
      autocomplete :user, :email
    end
    FakesController.send(:public, :autocomplete_select_clause)
  end
  after { Object.send :remove_const, :FakesController }
  subject { FakesController.new }

  context '#autocomplete_select_clause' do
    it 'with email value field' do
      expected = ['users.email', 'users.id']
      expect( subject.autocomplete_select_clause(User, :email, nil, {}) ).to contain_exactly(*expected)
    end

    it 'with email value and first_name label' do
      expected = ['users.email', 'users.id', 'users.first_name']
      expect( subject.autocomplete_select_clause(User, :email, :first_name, {}) ).to contain_exactly(*expected)
    end

    it 'with email value, first_name and last_name additional_data' do
      expected = ['users.email', 'users.id', 'users.first_name', 'users.last_name']
      expect(subject.autocomplete_select_clause(User, :email, nil, { additional_data: [:first_name, :last_name] })).to(
        contain_exactly(*expected))
    end
  end

  context '#autocomplete_where_clause' do
    it 'has where' do
      # expect(subject.auto)
    end
  end

  describe UsersController, type: :controller do
    it { respond_to? :autocomplete_user_email }

    context 'autcomplete with 3 users in db' do
      before :each do
        @user1 = create(:user, :with_full_name)
        create(:user, :with_full_name)
        create(:user, :with_full_name)
        get :autocomplete_user_email, search_term: 'user'
      end

      it 'is successful' do
        expect(response).to be_success
      end

      it 'returns 3 users' do
        expect(json.size).to eq(3)
      end
    end
  end
end
