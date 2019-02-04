require 'test_helper'

class PostTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @post = @user.posts.build(title:"test",content: "Lorem ipsum")
  end

  test "should be valid" do                                                     #サニティーチェック
    assert @post.valid?                                                         
  end

  test "user id should be present" do                                           #user_idのバリデーションが正しく働いているかのテスト
    @post.user_id = nil                                                         #user_idをnilにする
    assert_not @post.valid?                                                     #バリデーションチェック
  end
  
  test "content should be present" do                                           #contentのバリデーションが正しく働いているかのテスト
    @post.content = "   "
    assert_not @post.valid?
  end
  
  test "order should be most recent first" do                                   #表示順のテスト、最も新しい投稿が一番上に表示されるか
    assert_equal posts(:most_recent), Post.first                                #fixture内の最新の投稿がPostモデル一番上（つまり最新）の投稿と一致するか
  end
  
end