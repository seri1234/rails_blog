class Post < ApplicationRecord
  belongs_to :user                                                              #userモデルとの紐付け
  has_many :comments                                                            #コメントモデルとの紐付け
  default_scope -> { order(created_at: :desc) }                                 #デフォルトスコープ。データを降順として順番を保証。
  mount_uploader :picture, PictureUploader                                      #CarrierWaveに画像と関連付けたモデルを伝える
  validates :user_id, presence: true
  validates :title, presence: true
  validates :content, presence: true
  validate  :picture_size


  private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes                                             #5MB以上の場合はエラー
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
