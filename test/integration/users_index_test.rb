require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
  end
  
  
  test "index as admin including pagination and delete links" do                
    log_in_as(@admin)                                                           #@adminとしてログイン
    get users_path                                                              #ユーザ一覧ページにgetアクセス
    assert_template 'users/index'                                               #index.html.erbが描画されるか
    assert_select 'div.pagination'                                              #div.paginationがあるか
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|                                          #ページネーションの１ページ目でユーザーごとに繰り返す
      assert_select 'a[href=?]', user_path(user), text: user.name               #それぞれのプロフへのリンクがきちんと存在するか
      unless user == @admin                                                     #もしuserがログインしている管理者ユーザでなければ
      assert_select 'a[href=?]', user_path(user), text: 'delete'                #それぞれの削除へのリンクがきちんと存在するか
      end
    end
    assert_difference 'User.count', -1 do                                       #下のことをするとUserモデルのデータが一つ減るか
      delete user_path(@non_admin)                                              #@non_adminでuser_pathにdeleteアクセス
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)                                                       #非管理者ユーザとしてログイン
    get users_path                                                              #ユーザ一覧ページにgetアクセス
    assert_select 'a', text: 'delete', count: 0                                 #削除へのリンクが存在していないか
  end
end