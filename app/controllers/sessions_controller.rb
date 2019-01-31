class SessionsController < ApplicationController

  def new
  end

  def create                                                                    #/login(login_path)にpostアクセス。ログインする
    user = User.find_by(email: params[:session][:email].downcase)               #送られたparamsのsession情報のemailと同じemailのユーザをUserモデルから検索
    if user && user.authenticate(params[:session][:password])                   #もし該当ユーザーがいて、authenticateメソッドの判定機能でパスワードとも一致したら
      log_in user                                                               #userとしてログイン。sessions_helperのlog_inメソッドを使用
      redirect_to user                                                          #/users/idにリダイレクト
    else
      flash.now[:danger] = 'Invalid email/password combination'                 #もし該当ユーザがいないか、パスワードが正しくなければ、失敗flashをこのページで表示
      render 'new'                                                              #newを再描画
    end
  end
  
  def destroy                                                                   #/logout(logout_path)にdeleteアクセス。ログアウトする
    log_out                                                                     #sessions_helperのlogoutメソッドを実行
    redirect_to root_url                                                        #ルートページにリダイレクト
  end
end