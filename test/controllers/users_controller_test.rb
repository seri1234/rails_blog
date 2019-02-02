require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
  
  test "should redirect index when not logged in" do                            
    get users_path                                                              #未ログイン状態で/usersユーザー一覧ページにgetアクセス。
    assert_redirected_to login_url                                              #きちんとログインページにリダイレクトされるか
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when not logged in" do                             #ログインしていない状態でユーザー情報更新ページ/users/:id/editアクセスするときちんとリダイレクトされるか
    get edit_user_path(@user)                                                   #未ログイン状態で/users/:id/editアクセス
    assert_not flash.empty?                                                     #エラーフラッシュが表示されるか
    assert_redirected_to login_url                                              #アクセス失敗の結果、ログインページに飛ばされるか
  end

  test "should redirect update when not logged in" do                           #ログインしていない状態で/users/:idにpatchアクセスでデータを送るときちんとエラーが出るか
    patch user_path(@user), params: { user: { name: @user.name,                 #未ログイン状態で/users/:idにpostアクセスでデータを送る
                                              email: @user.email } }            #
    assert_not flash.empty?                                                     #エラーフラッシュが表示されるか
    assert_redirected_to login_url                                              #アクセス失敗の結果、ログインページに飛ばされるか
  end
  
  test "should not allow the admin attribute to be edited via the web" do       #管理者権限を持たない人が、admin属性を偽って/users/idにPachアクセスした時、きちんと阻止できるか
    log_in_as(@other_user)                                                      #fixutreの管理者権限を持たない人としてログイン
    assert_not @other_user.admin?                                               #管理者権限を持たない人か？
    patch user_path(@other_user), params: {                                     #管理者権限を持たない人がadmin:trueと偽って/users/idにpachアクセス
                                    user: { password:             "",
                                            password_confirmation: "",
                                            admin: true } }                     #adminをtrueにしようと試みる
    assert_not @other_user.reload.admin?                                        #@other_userを再読込して、adminがfalseのままか？
  end
  
  test "should redirect edit when logged in as wrong user" do                   #違うユーザーのログインでユーザー情報更新ページ/users/:id/editアクセスするときちんとリダイレクトされるか
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do                 #違うユーザーのログインで/users/:idにpatchアクセスでデータを送るときちんとエラーが出るか
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect destroy when not logged in" do                          #未ログイン状態でユーザ情報を削除するときちんと失敗するか
    assert_no_difference 'User.count' do                                        #下のことをしてもUserモデルのデータ数は変わらないか
      delete user_path(@user)                                                   #@userでdeleteアクションアクセス
    end
    assert_redirected_to login_url                                              #きちんとリダイレクトされるか
  end

  test "should redirect destroy when logged in as a non-admin" do               #非管理者ユーザーでユーザー情報を削除するときちんと失敗するか
    log_in_as(@other_user)                                                      #非管理者ユーザーでログイン
    assert_no_difference 'User.count' do                                        #下のことをしてもUserモデルのデータ数は変わらないか
      delete user_path(@user)                                                   #@userでdeleteアクションアクセス
    end
    assert_redirected_to root_url                                               #きちんとリダイレクトされるか
  end
  
end
  