# frozen_string_literal: true

require 'application_system_test_case'

class BooksTest < ApplicationSystemTestCase
  setup do
    @book = books(:abc_book)

    # ログイン
    visit root_path
    click_on 'ログイン'

    fill_in 'メールアドレス', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
  end

  def write_comment(book, comment)
    visit book_path(book)
    fill_in 'comment_body', with: comment
    click_on 'コメントする'
  end

  test 'インデックスのタイトル' do
    visit root_path
    assert_selector 'h1', text: '書籍一覧'
  end

  test '書籍一覧ページ' do
    visit books_path
    click_on '新しい本を追加する'
    assert_selector 'h1', text: '新しい本の追加'
    click_on 'もどる'

    click_on '詳細'
    assert_selector 'h1', text: '本の詳細'
    click_on 'もどる'

    click_on '編集'
    assert_selector 'h1', text: '本の情報を編集'
    click_on 'もどる'
  end

  test '新しい本を追加する' do
    visit new_book_path

    fill_in 'タイトル', with: '単語'
    fill_in 'メモ', with: '覚えるよ'
    fill_in '著者', with: 'なんとかさん'
    click_on '追加'

    assert_text '保存しました'
    assert_selector '#book-title', text: '単語'
    assert_selector '#book-memo', text: '覚えるよ'
    assert_selector '#book-author', text: 'なんとかさん'
  end

  test '本の編集' do
    visit edit_book_path(@book)

    fill_in 'タイトル', with: '上書きタイトル'
    fill_in 'メモ', with: '上書きメモ'
    fill_in '著者', with: '上書き著者'
    click_on '追加'

    assert_text '更新しました'

    visit book_path(@book)
    assert_selector '#book-title', text: '上書きタイトル'
    assert_selector '#book-memo', text: '上書きメモ'
    assert_selector '#book-author', text: '上書き著者'
  end

  test '本の削除' do
    visit books_path
    page.accept_confirm do
      click_on '削除'
    end

    assert_text '削除しました'
  end

  test 'コメントする' do
    write_comment(@book, 'コメントします！')

    assert_text 'コメントの作成に成功しました'
    assert_selector '.comment-body', text: 'コメントします！'
  end

  test 'コメントを削除する' do
    write_comment(@book, 'コメントします！')
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

    click_on @book.user.name
    assert has_no_button?('フォロー')
  end

  test '未ログインユーザーは新規投稿、編集ページへ行くとnotice文を表示する' do
    click_on 'ログアウト'
    assert_text 'ログアウトしました。'

    visit new_book_path
    assert_text 'アカウント登録もしくはログインしてください。'

    visit edit_book_path(@book)
    assert_text '投稿者でないと編集や削除は行えません'
  end
end
