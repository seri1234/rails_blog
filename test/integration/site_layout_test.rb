require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
#レイアウトに関する統合テスト

  test "layout links" do                                                        #レイアウトのリンクに関するテスト
    get root_path                                                               #/にgetアクセス
    assert_template 'static_pages/home'                                         #static_pages/homeが描画されるか
    assert_select "a[href=?]", root_path, count: 2                              #/へのリンクが２つあるか
    assert_select "a[href=?]", about_path                                       #/aboutへのパスがあるか
    assert_select "a[href=?]", contact_path                                     #/contactへのパスがあるか
  end
end
