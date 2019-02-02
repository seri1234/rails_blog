require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "unsuccessful edit" do                                                   #無効な情報でユーザー情報を更新するテスト
    log_in_as(@user)                                                            #@userとしてログイン
    get edit_user_path(@user)                                                   #/users/id/editにgetアクセス。ユーザー情報更新ページを表示
    assert_template 'users/edit'                                                #edit.html.erbがきちんと描画されるか
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }  #/users/id/にpatchアクセス。無効な情報で更新
    assert_template 'users/edit'                                                #失敗した結果edit.html.erbがきちんと再描画されるか
  end
  
  test "successful edit with friendly forwarding" do                            #有効な情報でフレンドリーフォワーディング機能テスト。
    get edit_user_path(@user)                                                   #未ログイン状態で/users/id/editにgetアクセス。
    log_in_as(@user)                                                            #ログインページになるのでログイン
    assert_redirected_to edit_user_url(@user)                                   #フレンドリーフォワーディングにより/users/id/editにリダイレクト。ユーザー情報更新ページを表示
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?                                                     #フラッシュが空ではないか。つまりフラッシュがきちんと表示されているか
    assert_redirected_to @user                                                  #/users/idにリダイレクトされるか
    @user.reload                                                                #データベースから最新のユーザー情報を読み込み直して、正しく更新されたかどうかを確認している
    assert_equal name,  @user.name                                              #DBのnameカラムがきちんと"Foo Bar" になっているか
    assert_equal email, @user.email                                             #DBのemailカラムがきちんと"foo@bar.com"  になっているか
  end
end