class Item < ActiveRecord::Base
  belongs_to :user
  attr_accessor :avatar
  validates :name, presence: true
  validates :price, presence: true
  has_attached_file :avatar,  :styles => {
      :thumb => "100x100#",
      :small  => "150x150>",
      :medium => "200x200" }, default_url: "Default_:style.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
private

    # Removes avatar
    def delete_avatar
      self.avatar = nil
    end
end
