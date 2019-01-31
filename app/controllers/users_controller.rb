class UsersController < ApplicationController
  
  def show
   @user = User.find(params[:id])

  end
  
  def new
    @user = User.new
  end
  
  
  def create                                                                    #/signup（users_path）にアクセス、フォームのユーザー情報をDBに保存
  @user = User.new(user_params)                                                 #user_paramsよりparams@userを作成
    if @user.save                                                               #もし成功すればsaveしてデータベースに保存
      flash[:success] = "Welcome to Kohei's blog!"                              #成功フラッシュ
      redirect_to @user                                                         #user_url(@user)にリダイレクト(/users/id)、プロフィールページを表示。
    else                                                                        #もし失敗なら
      render 'new'                                                              #newを再描画
    end
  end
  
  
  private                                                                       #外部から使えないようにする

    def user_params                                                             #paramsの戻り値をuser属性のname, 
      params.require(:user).permit(:name, :email, :password,                    #:email, :password, :password_confirmationのみ許可する
                                   :password_confirmation)
    end
end 