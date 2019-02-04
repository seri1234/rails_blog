Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'                                              #/signup(signup_path)にgetアクセスでnewアクションを実行。ユーザー情報登録ページを表示
  post '/signup',  to: 'users#create'                                           #/signup(signup_path)にpostアクセスでcreateアクションを実行。フォーム内容をUserモデルに記録。
  get    '/login',   to: 'sessions#new'                                         #/login(login_path)にgetアクセスでnewアクションを実行。ログインページを表示
  post   '/login',   to: 'sessions#create'                                      #/login(login_path)にpostアクセスでcreateアクションを実行。ログインする
  delete '/logout',  to: 'sessions#destroy'                                     #/logout(login_path)にdeleteアクセスでdestroyアクションを実行。ログアウトする
  resources :users                                                              #users_path       GET    /users          users#index    ユーザ一覧
                                                                                #edit_users_path  GET    /users/:id/edit users#edit     ユーザー情報更新ページを表示
                                                                                #user_path(user)  GET    /users/:id      users#show     ユーザープロフィールページを表示
                                                                                #user_path(user)  PATCH  /users/:id      users#update   ユーザー情報を更新して保存
                                                                                #user_path(user) DELETE /users/:id      users#destroy  ユーザー情報を削除
  resources :posts,          only: [:show,:create, :destroy]                    #/posts/id (post_path(post_id))にgetアクセスでshowアクションを実行。記事詳細画面を表示
                                                                                #/posts(posts_path)にpostアクセスでcreatアクションを実行。記事を投稿する。
                                                                                #/posts/id (post_path(post_id))にdeleteアクセスでdestroyアクションを実行。記事を削除する
end