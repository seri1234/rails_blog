class User < ApplicationRecord
  before_save { self.email = email.downcase }                                   #save直前にemailを小文字に変換する
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i        #メールアドレスの正しいフォーマットの正規表現
  validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },                      #メールアドレスの正しいフォーマットのバリデーション
                      uniqueness: { case_sensitive: false }                     #アドレスは重複してはいけない（大文字小文字を区別しない）
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }                 
end