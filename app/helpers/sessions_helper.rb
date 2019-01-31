module SessionsHelper

  def log_in(user)                                                              #引数のユーザーとしてログインする
    session[:user_id] = user.id                                                 #session[:user_id]にuser.idを暗号化した状態で代入。
  end
  
  #もしログインしているユーザがいれば現在のユーザーを返す
  def current_user                                                              
    if session[:user_id]                                                        #もしsession[:user_id]に値があれば
      @current_user ||= User.find_by(id: session[:user_id])                     #@current_userを返す。もし@current_userに値がなければUserモデルから
    end                                                                         #session[:user_id]のidユーザを検索して返す
  end
  
  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?                                                                #logged_inメソッド。htmlのログイン判定で使う
    !current_user.nil?                                                          #current_userに値があればtrue、無ければfalseを返す。
  end

  # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)                                                    #sessionのユーザーidを消してログアウト準備
    @current_user = nil                                                         #@current_userにnilを返す
  end
end