require 'test_helper'

class PostsInterfaceTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  
  def setup
    @user = users(:michael)
  end

  test "post interface" do                                                      #記事投稿機能の統合テスト                                               
    log_in_as(@user)                                                            #@userとしてログイン
    get root_path                                                               #ルートページにgetアクセス
    assert_select 'div.pagination'                                              #'div.pagination' が含まれているか
    assert_select 'input[type="file"]'                                          #'input[type="file"]'が含まれているか（画像アップロード部分）
    # 無効な送信
    assert_no_difference 'Post.count' do                                        #以下のことをしてもPostのデータ数が変わらないか
      post posts_path, params: { post: { title: "",content: "" } }              #空文字をpostアクセスでposts_pathに送信する
    end
    assert_select 'div#error_explanation'                                       #div#error_explanationが含まれているか
    # 有効な送信
    title = "title test"
    content = "a" * 30 + "b" * 30                                               #有効なテスト用タイトルと、本文、
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')       #テスト用の画像を用意
    assert_difference 'Post.count', 1 do                                        #以下のことをするとPostモデルにデータが１つ増えるか
      post posts_path, params: { post: {  title: title ,
                                          content: content,
                                          picture: picture } }                  #有効な情報をpostアクセスでposts_pathに送信する
    end
    assert assigns(:post).picture?                                              #current_user.posts.pictureの中身があるか。assignでcreateの@postにアクセスできる
    follow_redirect!                                                            #リダイレクトを反映
    assert_match title, response.body                                           #html内に投稿されたタイトルがあるか
    assert_select "a[href=?]",post_path(Post.first), count: 3                   #投稿された記事の記事詳細ページへのリンク2つと、削除ページが存在するか
    assert_match Post.first.content.truncate(50), response.body                 #投稿された記事が５０文字+...と省略された状態で、html内に存在しているか
    
    
    # 記事詳細表示機能
    get post_path(Post.first.id)                                           #/posts/Post.firstにgetアクセス。最新の投稿の記事詳細ページ。
    assert_select 'title', full_title(title)                                    #titleが投稿された記事のタイトルになっているか
    assert_match title, response.body                                           #html内に投稿されたタイトルがあるか
    assert_match Post.first.content, response.body                              #html内に投稿された本文が省略されていない形で存在するか
    #コメント投稿機能
    post post_comments_path(Post.first.id) ,params: { post_id: Post.first.id,
                                                      user_id: @user.id,
                                                      comment: { content: "Lorem ipsum" } }
    get post_path(Post.first.id)   
    assert_select 'h2', "記事へのコメント一覧"
    assert_match "Lorem ipsum" , response.body
    assert_select  'a', text: @user.name, count: 2 

    
    # 投稿を削除する
    get root_path 
    assert_select 'a', text: '削除'                                             #削除リンクが存在するか
    first_post = @user.posts.paginate(page: 1).first                            #ページネーション内の最初の@user.posts
    assert_difference 'Post.count', -1 do                                       #以下のことをするとPostモデルのデータが1つ減るか
      delete post_path(first_post)                                              #post_path(first_post)にdeleteアクセス
    end
    # 違うユーザーのプロフィールにアクセス (削除リンクがないことを確認)
    get user_path(users(:archer))                                               #違うユーザーのプロフィールページにアクセス
    assert_select 'a', text: '削除', count: 0                                   #削除リンクが一つも無いか
  end
end