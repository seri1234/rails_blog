class CommentsController < ApplicationController
  before_action :logged_in_user
  
  def create                                                                    #/posts/posts_id/comentにpostアクセスでcreateアクションを実行。コメントを投稿する
    @comment = Post.find(params[:post_id]).comments.new(comment_params)         #paramsから@commentを作成。その際Postも紐付ける
    @comment.user_id = current_user.id                                          #ログインしている自分自身のidを代入
    if @comment.save!                                                            #もし無事に保存できたら
      flash[:success] = "comment saved!" 
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end

  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end