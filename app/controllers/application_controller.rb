class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private
  
    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?                                                         #logged_in?がfalseの場合
        store_location
        flash[:danger] = "Please log in."                                       #失敗フラッシュを表示
        redirect_to login_url                                                   #ログインページへ
      end
    end
end
