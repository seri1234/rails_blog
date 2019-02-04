require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test "profile display" do                                                     #ユーザーロフィールページのテスト
    get user_path(@user)                                                        #user/idにgetアクセス
    assert_template 'users/show'                                                #show.html.erbがきちんと表示されているか
    assert_select 'title', full_title(@user.name)                               #title部分にユーザーの名前があるか
    assert_select 'h1', text: @user.name                                        #h1タグにユーザーの名前があるか
    assert_match @user.posts.count.to_s, response.body                          #ユーザーの投稿数がhtmlファイル内に存在するか
    assert_select 'div.pagination'                                              #div.paginationが存在するか
    @user.posts.paginate(page: 1).each do |post|                                #ページネーションのページ１の投稿を一つずつテストする
      assert_match post.title,response.body                                     #post.title(タイトル)がそれぞれに含まれているか。
      assert_match post.content.truncate(50), response.body                     #post.content.truncate(50)(50文字に省略された本文)がそれぞれに含まれているか。
    end
  end
end