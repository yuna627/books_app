# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:eating_report)

    # ログイン
    visit root_path
    click_on 'ログイン'

    fill_in 'メールアドレス', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    click_on '日報一覧'
  end

  def write_comment(book, comment)
    visit report_path(book)
    fill_in 'comment_body', with: comment
    click_on 'コメントする'
  end

  test 'インデックスのタイトル' do
    visit reports_path
    assert_selector 'h1', text: '日報一覧'
  end

  test '日報一覧ページ' do
    visit reports_path
    click_on '日報を書く'
    assert_selector 'h1', text: '日報を書く'
    click_on 'もどる'

    click_on '詳細'
    assert_selector 'h1', text: '日報の詳細'
    click_on 'もどる'

    click_on '編集'
    assert_selector 'h1', text: '日報を編集する'
    click_on 'もどる'
  end

  test '日報を書く' do
    visit new_report_path

    fill_in 'タイトル', with: '買い物リスト'
    fill_in 'メモ', with: '卵、鶏肉'
    click_on '追加'

    assert_text '保存しました'
    assert_selector '#report-title', text: '買い物リスト'
    assert_selector '#report-memo', text: '卵、鶏肉'
  end

  test '日報の編集' do
    visit edit_report_path(@report)

    fill_in 'タイトル', with: '上書きです'
    fill_in 'メモ', with: 'テストです'
    click_on '追加'

    assert_text '更新しました'

    visit report_path(@report)
    assert_selector '#report-title', text: '上書きです'
    assert_selector '#report-memo', text: 'テストです'
  end

  test '日報の削除' do
    visit reports_path
    page.accept_confirm do
      click_on '削除'
    end

    assert_text '削除しました'
  end

  test 'コメントする' do
    write_comment(@report, 'コメントします！')

    assert_text 'コメントの作成に成功しました'
    assert_selector '.comment-body', text: 'コメントします！'
  end

  test 'コメントを削除する' do
    write_comment(@report, 'コメントします！')
    page.accept_confirm do
      click_on '削除'
    end
  end

  test '未ログインユーザーは投稿や編集が出来ない' do
    click_on 'ログアウト'
    assert_text 'ログアウトしました。'

    assert has_no_text?('新しい本を追加する')
    assert has_no_text?('編集')

    click_on '詳細'
    assert has_no_text?('編集')
    assert has_no_button?('コメントする')

    click_on @report.user.name
    assert has_no_button?('フォロー')
  end

  test '未ログインユーザーは新規投稿、編集ページへ行くとnotice文を表示する' do
    click_on 'ログアウト'
    assert_text 'ログアウトしました。'

    visit new_report_path
    assert_text 'アカウント登録もしくはログインしてください。'

    visit edit_report_path(@report)
    assert_text '投稿者でないと編集や削除は行えません'
  end
end
