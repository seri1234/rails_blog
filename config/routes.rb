Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'                                              #/users（users_path）にgetアクセスでnewアクションが実行。ユーザー情報登録ページを表示
  post '/signup',  to: 'users#create'                                           #/users（users_path）にpostアクセスでcreateアクションが実行。フォーム内容をUserモデルに記録。
  resources :users                                                              
  
end