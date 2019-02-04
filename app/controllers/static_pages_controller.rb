class StaticPagesController < ApplicationController
  
  def home                                                                      #ホームページにgetアクセス。
    if logged_in?
      @post  = current_user.posts.build                                         #フォームで使用
      @feed_items = current_user.feed.paginate(page: params[:page])             #記事一覧表示に使用
    end
  end

  def about
  end
  
  def contact
  end
end
