require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:michael)
    remember(@user)
  end
                                                                                #current_userメソッドの複雑な分岐処理に対するテスト。２重のif文の内側の条件分岐まできちんとテスト
  test "current_user returns right user when session is nil" do                 #sessionには値を入れないで、クッキーのuser_idと:remember_tokenは値がある状態。
    assert_equal @user, current_user                                            #@userとcurrent_userは同じか。つまりcurrent_userメソッドの@current_user = userまで実行されているか。
    assert is_logged_in?                                                        #ログインできているか？
  end

  test "current_user returns nil when remember digest is wrong" do              #間違ったremember_digestの時に、currentuserはきちんとnilを返すかのテスト
    @user.update_attribute(:remember_digest, User.digest(User.new_token))       #remember_digestに新しい値を保存
    assert_nil current_user                                                     #currentuserはきちんとnilを返すか
  end
end