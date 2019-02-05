require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  
#静的なページの単体テスト
  test "should get home" do                                                     #root_path(/)にgetアクセスでページがきちんと表示され、
    get root_path                                                               #titleもきちんとKohei's blogと表示されるか
    assert_response :success
    assert_select "title", "Kohei's blog"                                       #homeではkohei's blogとだけ表示
  end
  
  test "should get about" do                                                    #about_path(/about)にgetアクセスでページがきちんと表示され、
    get about_path                                                              #titleもきちんと表示されるか
    assert_response :success
    assert_select "title", "About | Kohei's blog"
  end
  
  test "should get contact" do                                                  #contact_path(/contact)にgetアクセスでページがきちんと表示され、
    get contact_path                                                            #titleもきちんと表示されるか
    assert_response :success
    assert_select "title", "Contact | Kohei's blog"
  end
  
end