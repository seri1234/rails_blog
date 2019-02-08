class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]       #アクションの直前にログインしているかの判定
  before_action :correct_user,   only: [:edit, :update]                         #アクションの直前に正しいログインユーザーか判定
  before_action :admin_user,     only: :destroy                                 #管理者権限を持つユーザーか判定
  
  
  def index                                                                     #/users(users_path)にgetアクセス。ユーザー一覧ページを表示
    @users = User.paginate(page: params[:page])
  end


  def show                                                                      #/users/id user_path(user)にgetアクセス。ユーザープロフィールページを表示
    @user = User.find(params[:id])
    @posts = @user.posts.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def create                                                                    #/signup（signup_path）にpostアクセス、フォームのユーザー情報をDBに保存
  @user = User.new(user_params)                                                 #user_paramsよりparams@userを作成
    if @user.save                                                               #もし成功すればsaveしてデータベースに保存
      log_in @user
      flash[:success] = "Kohei's blogへようこそ!"                              #成功フラッシュ
      redirect_to @user                                                         #user_url(@user)にリダイレクト(/users/id)、プロフィールページを表示。
    else                                                                        #もし失敗なら
      render 'new'                                                              #newを再描画
    end
  end
  
  def edit                                                                      #/users/id/edit(edit_path(user))でgetアクセス。ユーザー情報更新ページを表示
    @user = User.find(params[:id])
  end
  
  def update                                                                    #	/users/idに(update_path(user))patchアクセス。DBのユーザー情報を更新する。
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)                                     #もし更新が成功したら(セキュリティのためstrong parameterを使う)
      flash[:success] = "登録情報の更新に成功しました！"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy                                                                   #/users/:id　user_path(user) にdeleteアクセス。特定のユーザーを削除
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました"
    redirect_to users_url                                                       #ユーザ一覧にアクセス
  end
  

  private                                                                       #外部から使えないようにする

    #Strong Parameters
    def user_params                                                             #paramsの戻り値をuser属性のname, 
      params.require(:user).permit(:name, :email, :password,                    #:email, :password, :password_confirmationのみ許可する
                                   :password_confirmation,:picture)
    end

    # beforeフィルター

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])                                            #URLに含まれている情報からparams[:id]のユーザー情報を取得
      redirect_to(root_url) unless current_user?(@user)                        #アクセスしたページのユーザーと、current_userが同じでなければルートページにリダイレクト
    end
    
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end