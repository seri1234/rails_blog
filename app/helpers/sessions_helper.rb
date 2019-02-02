module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)                                                              #引数のユーザーとしてログインする
    session[:user_id] = user.id                                                 #session[:user_id]にuser.idを暗号化した状態で代入。
  end
  
  # ユーザーのセッションを永続的にする
  def remember(user)                                                            #sessions_controllerのcreateアクションで使う
    user.remember                                                               #DBのUserモデルのremember_digestに永続化トークンを作成。user.rbのrememberメソッド
    cookies.permanent.signed[:user_id] = user.id                                #cookiesのuser_idに暗号化され、２０年使えるuser.idを入れる
    cookies.permanent[:remember_token] = user.remember_token                    #cookiesのremember_token２０年使えるuser.remember_token を入れる。user.rbのattr_accessor :remember_token を使う。
  end
  
  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)                                                       #users_controllerのcorrect_userメソッドで使用
    user == current_user                                                        #渡されたユーザーと現在のユーザーが同じならtrueを返す。
  end
  
  # 記憶トークンcookieに対応するユーザーを返す                                   まずsession[:user_id]（一時クッキー）を調べ、値があればそのユーザーを@currentを返す。
                                                                                #もし無ければ、cookies.signed[:user_id](永続的クッキー)を調べ、
                                                                                #更にセキュアにするために暗号化したcookies[:remember_token]（永続的クッキー）とremember_digestを比較した上で
                                                                                #log_inでsession[:user_id]に値を入れ、@curretn_userを返す・
  def current_user                                                              #viewにおいてログイン判定や、ログインユーザー情報を取得するのに使う
    if (user_id = session[:user_id])                                            #もしsession[:use_id]に値があれば（同時にuser_idに代入）
      @current_user ||= User.find_by(id: user_id)                               #@current_userに値があればそれを返し、無ければuser.idのユーザ情報を@curretn_userに代入して返す
    elsif (user_id = cookies.signed[:user_id])                                  #もしsession[:use_id]に値が無ければ、(同時にuser_idに代入)
      user = User.find_by(id: user_id)                                          #user.idのユーザ情報をuserに代入
      if user && user.authenticated?(cookies[:remember_token])                  #もし暗号化されたcookies[:remember_token]とremember_degestが同じなら
        log_in user                                                             #上のlog_inメソッドを実行してsession[:user_id]に値を入れる
        @current_user = user                                                    #@current_userを返す
      end
    end
  end
  
  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?                                                                #logged_inメソッド。htmlのログイン判定で使う
    !current_user.nil?                                                          #current_userに値があればtrue、無ければfalseを返す。
  end


  # 永続的セッションを破棄する
  def forget(user)
    user.forget                                                                 #userのUserモデルのremember_digestカラムの情報を削除。user.rbのforgetメソッドを使用
    cookies.delete(:user_id)                                                    #session[:user_id]を削除
    cookies.delete(:remember_token)                                             #session[remember_token]を削除
  end
  
  
  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)                                                        #上のfogetメソッドを実行して、永続的クッキーを削除
    session.delete(:user_id)                                                    #sessionのユーザーidを消してログアウト準備
    @current_user = nil                                                         #@current_userにnilを返す
  end
  
  # 記憶したURL (もしくはデフォルト値) にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)                            #
    session.delete(:forwarding_url)                                             #実際のリダイレクトは最後に実行されるので、この行は実行される
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?             #もしgetリクエストなら、session[:forwarding_url]にリクエストを保存しておく
  end
end