require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)                                                     #fixtureユーザー
  end
  

  test "login with invalid information" do                                      #無効な情報でログイン
    get login_path                                                              #ログインページにgetアクセス
    assert_template 'sessions/new'                                              #new.html.erbが描画されるか
    post login_path, params: { session: { email: "", password: "" } }           #/loginにpostアクセス。無効な情報をフォームで送信
    assert_template 'sessions/new'                                              #new.html.erbが再描画されるか
    assert_not flash.empty?                                                     #失敗フラッシュが表示されるか
    get root_path                                                               #ルートページに移動
    assert flash.empty?                                                         #きちんとフラッシュが消えているか
  end
  
    test "login with valid information followed by logout" do                   #正しい情報でログインするときちんとページが表示され、その後ログアウトできるか

    get login_path                                                              
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }              #正しい情報をフォームで送信
    assert is_logged_in?                                                        #ログインしているか
    assert_redirected_to @user                                                  #リダイレクト先は/user/user_idで合っているか
    follow_redirect!                                                            #postアクセスの結果を見て実際にリダイレクト
    assert_template 'users/show'                                                #show.html.erbが描画されるか
    assert_select "a[href=?]", login_path, count: 0                             #/loginのリンクの数が0か
    assert_select "a[href=?]", logout_path                                      #/logoutリンクがあるか
    assert_select "a[href=?]", user_path(@user)                                 #/user/user_idリンクがあるか
    delete logout_path                                                          #/logoutにdeletアクセス
    assert_not is_logged_in?                                                    #logged_in
    assert_redirected_to root_url                                               #ルートページにリダイレクトしているか
    follow_redirect!
    assert_select "a[href=?]", login_path                                       ##/loginリンクがあるか
    assert_select "a[href=?]", logout_path, count:0                             #/logoutリンクの数化0か
    assert_select "a[href=?]", logout_path ,count:0                             #/user/user_idリンクの数が0か
  end
end