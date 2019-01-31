require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do                                          #無効な新規ユーザ登録情報のテスト
    get signup_path                                                             #新規登録ページ/signupにgetアクセス
    assert_no_difference 'User.count' do                                        #以下のことをしてもUserモデルのデータ数が変わらないか
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }       #/usersに無効なフォーム内容でpostアクセス
    end
    assert_template 'users/new'                                                 #users/newが表示されるか
    assert_select 'div#error_explanation'                                       #div#error_explanation'が含まれるか
    assert_select 'div.field_with_errors'                                       #div.field_with_errorsが含まれるか
  end
  
  test "valid signup information" do                                            #有効な新規ユーザ登録情報のテスト
    get signup_path                                                             #新規登録ページ/signupにgetアクセ
    assert_difference 'User.count', 1 do                                        #以下のことをするとUserモデルのデータ数1増えるか
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }  #/usersに有効なフォーム内容でpostアクセス
    end
    follow_redirect!                                                            #postリクエストの結果を見て実際にユーザー情報ページにリダイレクト
    assert_template 'users/show'                                                #showがきちんと描画されているか
    assert_not flash.empty?                                                     #成功フラッシュあるか
    assert is_logged_in?                                                        #ログインされているか？test_hrlperのis_logged_in?メソッド
  end
end