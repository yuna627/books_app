# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @me = User.create!(email: 'me@example.com', password: 'password', name: 'me', uid: '1')
    @friend1 = User.create!(email: 'she@example.com', password: 'password', name: 'she', uid: '2')
    @friend2 = User.create!(email: 'he@example.com', password: 'password', name: 'he', uid: '3')
  end

  test '#follow' do
    assert_not @me.following?(@friend1)
    @me.follow(@friend1.id)
    assert @me.following?(@friend1)
  end

  test '#following?' do
    assert_not @me.following?(@friend1)
    assert_not @me.following?(@friend2)

    @me.follow(@friend1.id)

    assert @me.following?(@friend1)
    assert_not @me.following?(@friend2)
  end

  test '.create_unique_string' do
    uuid1 = User.create_unique_string
    uuid2 = User.create_unique_string

    assert_equal(36, uuid1.length, 'Length should be 36')
    assert_equal(36, uuid2.length, 'Length should be 36')
    assert_not_equal(uuid1, uuid2, 'Should be true because they must be unique')
  end

  test '.find_for_github_oauth' do
    github_user = User.create!(email: 'github_user@example.com', password: 'password', name: 'github_user',
                               uid: 'github_uid', provider: 'github')

    existing_auth = OmniAuth::AuthHash.new({
                                             'provider' => 'github',
                                             'uid' => 'github_uid',
                                             'info' => {
                                               'name' => 'github_user',
                                               'email' => 'github_user@example.com'
                                             }
                                           })

    returned_user = User.find_for_github_oauth(existing_auth)
    assert_equal(github_user, returned_user, 'Shold return existing user')

    new_auth = OmniAuth::AuthHash.new({
                                        'provider' => 'github',
                                        'uid' => 'github_uid_2',
                                        'info' => {
                                          'name' => 'github_user_2',
                                          'email' => 'github_user_2@example.com'
                                        }
                                      })

    new_user = User.find_for_github_oauth(new_auth)

    assert_equal(new_auth.provider, new_user.provider, 'Provider should be github')
    assert_equal(new_auth.uid, new_user.uid, 'Uid should be github_uid_2')
    assert_equal(new_auth.info.name, new_user.name, 'Name should be github_user_2')
    assert_equal(new_auth.info.email, new_user.email, 'Email should be github_user_2@example.com')
  end
end
