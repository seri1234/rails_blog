require 'test_helper'

class UserTest < ActiveSupport::TestCase
#Userモデルに対するテスト

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end


  test "should be valid" do                                                     #Userモデルの有効性のテスト                       
    assert @user.valid?                                                         #@userが有効かどうか
  end
  
  test "name should be present" do                                              #Userモデルnameの存在性presentバリデーションテスト
    @user.name = "     "                                                        #空文字列を@use.nameに代入
    assert_not @user.valid?                                                     #valid?でfalseがきちんと帰ってくるか
  end

  test "email should be present" do                                             #Userモデルemailの存在性presentバリデーションテスト
    @user.email = "     "                                                       #空文字列を@use.emailに代入
    assert_not @user.valid?                                                     #valid?でfalseがきちんと帰ってくるか
  end
  
  test "name should not be too long" do                                         #nameの長さに関するテスト
    @user.name = "a" * 51                                                       #nameを51文字にしたら
    assert_not @user.valid?                                                     #valid?でfalseがきちんと帰ってくるか
  end
  
  test "email should not be too long" do                                        #emailの長さに関するテスト
    @user.email = "a" * 244 + "@example.com"                                    #emailを244文字+@example.comで256文字にしたら
    assert_not @user.valid?                                                     #valid?でfalseがきちんと帰ってくるか
  end

  test "email validation should accept valid addresses" do                      #有効なメールフォーマットのテスト
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn ]                   #%wで有効なメールアドレスの文字列の配列を作成
    valid_addresses.each do |valid_address|                                     #それぞれのメールアドレスで判定をする
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"           #valid?でfalseがきちんと帰ってくるか
    end                                                                         #第二引数で失敗したメールアドレスを表示させるようにする
  end
  
    test "email validation should reject invalid addresses" do                  #無効なメールフォーマットのテスト
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.  #%wで無効なメールアドレスの文字列の配列を作成
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|                                 #それぞれのメールアドレスで判定をする
      @user.email = invalid_address                                       
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"   #valid?でfalseがきちんと帰ってくるか
    end                                                                         #第二引数で失敗したメールアドレスを表示させるようにする
  end
  
  test "email addresses should be unique" do                                    # 重複するメールアドレス拒否のテスト
    duplicate_user = @user.dup                                                  #@userを複製してduplicate_userに収納
    duplicate_user.email = @user.email.upcase                                   #emailを大文字に変換
    @user.save                                                                  #@userをsaveする
    assert_not duplicate_user.valid?                                            #すでに@userがあるので、falseがきちんと帰ってこなければならない
  end
  
    test "password should be present (nonblank)" do                             #passwordが空だと弾かれるかのテスト
    @user.password = @user.password_confirmation = " " * 6                      #空文字を６個セット
    assert_not @user.valid?                                                     #きちんとfalseになるか
  end

  test "password should have a minimum length" do                               #passwordが６文字以上無い時、きちんと弾かれるかのテスト
    @user.password = @user.password_confirmation = "a" * 5                      #aを５個セット
    assert_not @user.valid?                                                     #きちんとfalseになるか
  end
                                                                                #2種類のブラウザの片方だけログアウトして、remember_digestに値がない状況でもう片方を再起動した時したときのバグをシュミレート
  test "authenticated? should return false for a user with nil digest" do       #current_userメソッドの if user && user.authenticated?(cookies[:remember_token])の部分でエラーが出てしまうバグを検証
    assert_not @user.authenticated?('')                                         #user.authenticated?でnilが帰ってくるかどうか
  end                                                                           #authenticated?メソッドのreturn false if remember_digest.nil?の部分だけをテストするので、引数は(' ')空で構わない

  test "associated posts should be destroyed" do                                #Userモデルと関連されたpostはきちんと削除されるかのテスト
    @user.save
    @user.posts.create!(title: "test", content: "Lorem ipsum")                   #Postにデータを追加
    assert_difference 'Post.count', -1 do                                       #以下のことをするとPostのデータが1つ減るか
      @user.destroy                                                             #ユーザーデータを削除
    end
  end
end
