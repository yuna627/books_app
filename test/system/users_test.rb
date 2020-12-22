# frozen_string_literal: true

require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:alice)
  end

  test '新規登録' do
    visit root_path
    click_on '新規登録'
    fill_in '名前', with: 'bob'
    fill_in 'メールアドレス', with: 'hoge2@example.com'
    fill_in 'パスワード', with: '123456'
    fill_in '確認用パスワード', with: '123456'
    click_on 'アカウント登録'
    assert_text 'アカウント登録が完了しました。'
  end

  def login(mail, password)
    visit new_user_session_path
    fill_in 'メールアドレス', with: mail
    fill_in 'パスワード', with: password
    click_button 'ログイン'
  end

  test 'ログイン' do
    visit root_path
    click_on 'ログイン'

    fill_in 'メールアドレス', with: @user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
  end

  test 'マイページ編集' do
    login(@user.email, 'password')

    click_on 'マイページ'
    click_on 'プロフィールを編集する'

    fill_in '郵便番号', with: '111-1111'
    fill_in '住所', with: '日本'
    fill_in '自己紹介', with: 'こんにちは'
    fill_in '現在のパスワード', with: '123456'
    click_on '更新'

    assert_text 'プロフィール情報を更新しました。'

    click_on 'マイページ'
    assert_selector '.zipcode', text: '111-1111'
    assert_selector '.address', text: '日本'
    assert_selector '.introduction', text: 'こんにちは'
  end

  test 'フォロー一覧を見る' do
    login(@user.email, 'password')

    click_on 'マイページ'
    click_on "フォロー: #{@user.followings.count}"

    assert_selector 'h1', text: 'フォローリスト'
  end

  test 'フォロワー一覧を見る' do
    login(@user.email, 'password')

    click_on 'マイページ'
    click_on "フォロワー: #{@user.followers.count}"

    assert_selector 'h1', text: 'フォロワーリスト'
  end

  test 'フォローする' do
    @user2 = users(:bob)

    login(@user.email, 'password')

    visit user_path(@user2)
    click_button 'フォロー'

    visit followers_user_path(@user2)
    assert_text @user.name
  end

  test 'アンフォローする' do
    @user2 = users(:bob)

    login(@user.email, 'password')

    visit user_path(@user2)
    click_button 'フォロー'

    visit followers_user_path(@user2)
    assert_text @user.name

    visit user_path(@user2)
    click_button 'アンフォロー'
    visit followers_user_path(@user2)
    assert has_no_link?('@user.name')
  end
end
