Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'                                              #/users(users_path)にgetアクセスでnewアクションを実行。ユーザー情報登録ページを表示
  post '/signup',  to: 'users#create'                                           #/users(users_path)にpostアクセスでcreateアクションを実行。フォーム内容をUserモデルに記録。
  get    '/login',   to: 'sessions#new'                                         #/login(login_path)にgetアクセスでnewアクションを実行。ログインページを表示
  post   '/login',   to: 'sessions#create'                                      #/login(login_path)にpostアクセスでcreateアクションを実行。ログインする
  delete '/logout',  to: 'sessions#destroy'                                     #/logout(login_path)にdeleteアクセスでdestroyアクションを実行。ログアウトする
  resources :users                                                              #users    GET    /users(.:format)          users#index ユーザ一覧
                                                                                #edit_userGET    /users/:id/edit(.:format) users#edit
                                                                                #user     GET    /users/:id(.:format)      users#show
                                                                                # =>      PATCH  /users/:id(.:format)      users#update
                                                                                # =>      PUT    /users/:id(.:format)      users#update
                                                                                # =>      DELETE /users/:id(.:format)      users#destroy
  
end