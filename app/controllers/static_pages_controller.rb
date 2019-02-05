class StaticPagesController < ApplicationController
  
  def home                                                                      #ホームページにgetアクセス。
    @feed_items =Post.paginate(page: params[:page])                             #記事一覧表示に使用
  
    if logged_in? 
      @post  = current_user.posts.build                                         #フォームで使用
    end                
  end

  def about
  end
  
  def contact
  end
end
