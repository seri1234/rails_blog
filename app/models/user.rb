class User < ApplicationRecord
  attr_accessor :remember_token                                                 #直接DB上に平文のtokenを置くのは危険なので、仮想のremember_token属性を作る
  before_save { self.email = email.downcase }                                   #save直前にemailを小文字に変換する
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i        #メールアドレスの正しいフォーマットの正規表現
  validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },                      #メールアドレスの正しいフォーマットのバリデーション
                      uniqueness: { case_sensitive: false }                     #アドレスは重複してはいけない（大文字小文字を区別しない）
  has_secure_password                                                           #has_secure_passwordが提供するauthenticateメソッドを使えるようにある                                                           
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true  #allow_nil:trueでパスワードの値が空だったらこの行のバリデーションをスキップ。
                                                                                #ユーザー情報更新画面でパスワード欄が空でもバリデーションエラーで引っかからないようにする
                                                                                #has_secure_passwordに存在性をチェックする機能があるので、新規作成時の時に空だときちんとエラーが出る。
                                                                                #また、presence:trueがないと、"   "のような空文字で通ってしまう。
  # 渡された文字列を暗号化して値を返す
  def User.digest(string)                                                       #テスト用fixtureのpassword_digest作成に使う
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost           #ハッシュ化の計算コストを最小にする。
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す
  def User.new_token                                                            #永続化cookiesやアカウントの有効化のリンクやパスワードリセットのリンクで使う
    SecureRandom.urlsafe_base64                                                 #ランダムな値を返す。SecureRandomモジュールのurlsafe_base64を使う
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token                                        #上で定義されたremember_token属性に新しいトークンを代入
    update_attribute(:remember_digest, User.digest(remember_token))             ##作成したトークンを暗号化し、Userモデルの:remember_digestカラムに上書きする。
  end
  
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)                                            #ここでのremember_tokenはauthenticated?内のローカル変数
    return false if remember_digest.nil?                                        #2種類のブラウザの片方だけログアウトして、remember_digestに値がない状況でもう片方を再起動した時したときのバグ対策
                                                                                #sessions_helperのcurrent_userメソッドの２つの条件式を通り抜け、
                                                                                #if user && user.authenticated?(cookies[:remember_token])のところでremember_digestに値がないため、エラーが出てしまう事に対処
    BCrypt::Password.new(remember_digest).is_password?(remember_token)          #ブラウザのcookieトークンとDBのremember_digestと比較、一致したらtrueを返す。
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)                                     #remember_degestをnilにする
  end
  
end