class PostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy                                 #削除時に投稿がなければリダイレクト

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments                                                  #コメント表示用@comments
    @comment = Comment.new                                                      #コメント投稿用@comment
  end

  def create                                                                    #/posts(posts_path)にpostアクセス。記事を投稿
    @post = current_user.posts.build(post_params)                               #post_paramsの内容でcurrent_userに紐付いた@postを生成
    if @post.save                                                               #もし@postへのDBの保存が成功したら
      flash[:success] = "Post created!"                                         #成功フラッシュ
      redirect_to root_url                                                      #ルートページにリダイレクト
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy                                                                   #/posts/id (post_path(post))にdeleteアクセス。記事を削除
    @post.destroy
    flash[:success] = "post deleted"
    redirect_to request.referrer || root_url                                    #Homeページ、プロフィールページ、記事詳細ページどれから削除された場合でも元のページにリダイレクト
  end

  private

    def post_params                                                             #ストロングパラメーター
      params.require(:post).permit(:title,:content, :picture)                   #postのtitleとcontentとpictureのみを許可
    end
    
    def correct_user
      @post = current_user.posts.find_by(id: params[:id])                       #今ログインしているユーザーの投稿を@postに代入
      redirect_to root_url if @post.nil?                                        #もし投稿が見つからなければルートページにリダイレクト
    end
    
    
end