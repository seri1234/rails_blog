require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest


  test "should redirect create when not logged in" do
    assert_no_difference 'Comment.count' do                                     #以下のことをしてもCommentモデルのデータ数は変わらないか
      post post_comments_path(1), params: { post_id: 1,
                                            user_id: 1,
                                          comment: { content: "Lorem ipsum" } } #post_comments_pathにpostアクセス。コメントを投稿
    end
    assert_redirected_to login_url                                              #きちんと失敗してログインページにリダイレクトされるか
  end
end