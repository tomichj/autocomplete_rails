require 'spec_helper'

describe AutocompleteRails::Controller do
  before(:all) do
    @user1 = create(:user, :with_full_name)
    @user2 = create(:user, :with_full_name)
  end

  before do
    class FakesController < ApplicationController
      include AutocompleteRails::Controller
      autocomplete :user, :email
    end
    FakesController.send(:public, :autocomplete_select_clause, :autocomplete_where_clause, :autocomplete_order_clause,
                         :autocomplete_limit_clause, :autocomplete_build_json)
  end
  after { Object.send :remove_const, :FakesController }
  subject { FakesController.new }

  context '#autocomplete_select_clause' do
    it 'with email value field' do
      expected = %w(users.email users.id)
      expect( subject.autocomplete_select_clause(User, :email, nil, {}) ).to contain_exactly(*expected)
    end

    it 'with email value and first_name label' do
      expected = %w(users.email users.id users.first_name)
      expect( subject.autocomplete_select_clause(User, :email, :first_name, {}) ).to contain_exactly(*expected)
    end

    it 'with email value, first_name and last_name additional_data' do
      expected = %w(users.email users.id users.first_name users.last_name)
      expect(subject.autocomplete_select_clause(User, :email, nil, { additional_data: [:first_name, :last_name] })).to(
        contain_exactly(*expected))
    end
  end

  context '#autocomplete_where_clause' do
    it 'builds users.email where clause with search term' do
      expected = ['LOWER(users.email) LIKE LOWER(?)', 'gug']
      expect(subject.autocomplete_where_clause('gug', User, :email, {})).to contain_exactly(*expected)
    end

    it 'builds users.email where caluse with search term and ignores label' do
      expected = ['LOWER(users.email) LIKE LOWER(?)', 'gug']
      expect(subject.autocomplete_where_clause('gug', User, :email, { label_method: :fake_method })).to(
        contain_exactly(*expected))
    end

    it 'removes LOWER if case_sensitive set' do
      expected = ['(users.email) LIKE (?)', 'gug']
      expect(subject.autocomplete_where_clause('gug', User, :email, { case_sensitive: true })).to(
        contain_exactly(*expected))
    end
  end

  context '#autocomplete_order_clause' do
    it 'order clause sorts by value method' do
      expect(subject.autocomplete_order_clause(User, :email, {})).to eq('LOWER(users.email) ASC')
    end

    it 'order clause can be overriden' do
      expect(subject.autocomplete_order_clause(User, :email, { order: 'test' })).to eq 'test'
    end
  end

  context '#autocomplete_limit_clause' do
    it 'has a default limit' do
      expect(subject.autocomplete_limit_clause({})).to eq 10
    end

    it 'renders options limit' do
      expect(subject.autocomplete_limit_clause({ limit: 20 })).to eq 20
    end
  end

  context '#autocomplete_build_json' do
    it 'renders value-only' do
      expect(subject.autocomplete_build_json(User.all, :email, :email, {})).to(
        contain_exactly({ id: 1, label: @user1.email, value: @user1.email },
                        { id: 2, label: @user2.email, value: @user2.email }))
    end

    it 'renders value and label' do
      expect(subject.autocomplete_build_json(User.all, :email, :first_name, {})).to(
        contain_exactly({ id: 1, label: @user1.first_name, value: @user1.email },
                        { id: 2, label: @user2.first_name, value: @user2.email }))
    end

    it 'renders value, label, and additional data' do
      expect = [{ id: 1, label: @user1.first_name, value: @user1.email, last_name: @user1.last_name },
                { id: 2, label: @user2.first_name, value: @user2.email, last_name: @user2.last_name }]
      expect(subject.autocomplete_build_json(User.all, :email, :first_name, { additional_data: [:last_name] })).to(
        contain_exactly(*expect))
    end
  end

  describe UsersController, type: :controller do
    it { respond_to? :autocomplete_user_email }

    context 'simple search term' do
      before :each do
        get :autocomplete_user_email, term: 'user'
      end

      it 'is successful' do
        expect(response).to be_success
      end

      it 'returns 3 users' do
        expect(json.size).to eq(2)
      end
    end
  end
end
