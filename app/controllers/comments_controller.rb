class CommentsController < ApplicationController
  before_action :logged_in_user
  
  def create                                                                    #/posts/posts_id/comentにpostアクセスでcreateアクションを実行。コメントを投稿する
    @comment = Post.find(params[:post_id]).comments.new(comment_params)         #paramsから@commentを作成。その際Postも紐付ける
    @comment.user_id = current_user.id                                          #ログインしている自分自身のidを代入
    if @comment.save!                                                           #もし無事に保存できたら
      respond_to do |format|                                                    #Ajaxリクエストでも応答できるようフォーマットを選択
        format.html { redirect_back(fallback_location: root_path) }             #もしJavaScriptが使えないブラウザなら
        format.js   { render :comment_view}                                     #もしJavaScriptが使えれる環境なら、Ajaxにより、必要部分だけ再描画(comments/comment_view.js.erbを呼び出す)
      end
    else                                                                        #もしsave失敗したら
     render 'posts/show'                                                        #showページを再描画
    end
  end

  private
  def comment_params                                                            #ストロングパラメータ
    params.require(:comment).permit(:content, :post_id)
  end
end