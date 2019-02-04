require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @post = posts(:orange)
  end

  test "should redirect create when not logged in" do                           #未ログイン状態で/posts(posts_path)にpostアクセス。つまり記事投稿したらきちんとリダイレクトされるかのテスト
    assert_no_difference 'Post.count' do                                        #以下のことをしてもPostモデルのデータ数は変わらないか
      post posts_path, params: { post: { content: "Lorem ipsum" } }             #/posts(posts_path)にpostアクセス。記事を投稿
    end
    assert_redirected_to login_url                                              #きちんと失敗してログインページににリダイレクトされるか
  end

  test "should redirect destroy when not logged in" do                          #未ログイン状態で/posts/id (post_path(post))にdeleteアクセス。つまり記事削除ししたらきちんとリダイレクトされるかのテスト
    assert_no_difference 'Post.count' do
      delete post_path(@post)
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy for wrong micropost" do                         #自分以外の投稿を削除しようとするときちんとリダイレクトされるかのテスト
    log_in_as(users(:michael))                                                  #michaelとしてログイン
    post = posts(:ants)
    assert_no_difference 'Post.count' do                                        #以下のことをしてもPostモデルのデータ数は変わらないか
      delete post_path(post)                                                    #antsとしてpost_pathにdeleteアクセス。記事を削除
    end
    assert_redirected_to root_url                                               #きちんとリダイレクトされるか
  end

end