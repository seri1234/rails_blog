require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @comment = Comment.new(post_id: posts(:orange).id,
                                     user_id: users(:michael).id)
  end

  test "should be valid" do                                                     #サニティーチェック
    assert @comment.valid?
  end

  test "post_id should be present" do                                           #post_idは存在しなければならない
    @comment.post_id = nil                                                      #post_idがnilの時
    assert_not @comment.valid?                                                  #valid?できちんとfalseになるか
  end

  test "user_id should be present" do                                           ##post_idは存在しなければならない
    @comment.user_id = nil                                                      #post_idがnilの時
    assert_not @comment.valid?                                                  #valid?できちんとfalseになるか
  end
end