class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token, :remove_avatar
  before_save   :downcase_email, :delete_avatar, if: ->{ remove_avatar == '1' && !avatar_updated_at_changed? }
  before_create :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  has_attached_file :avatar,  :styles => {
      :thumb => "100x100#",
      :small  => "150x150>",
      :medium => "200x200" }, default_url: "Default_:style.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  VALID_ZIPCODE_REGEX = /(^\d{5}$)|(^\d{5}-\d{4}$)/
  validates :zipcode, presence: true, length: { maximum: 10 },
		    format: { with: VALID_ZIPCODE_REGEX }
  validates :food, length: {maximum: 255}
  serialize :messages,Array
  acts_as_mappable :default_units => :miles,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :lat,
                   :lng_column_name => :lng
             	
  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  #add lat and lng to users, have zipcode translated and stored
  def store_location
    loc = Geokit::Geocoders::GoogleGeocoder.geocode "#{self.zipcode}"
    if loc.success
      update_attribute(:lat, loc.lat)
      update_attribute(:lng, loc.lng)
    end
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
  digest = send("#{attribute}_digest")
  return false if digest.nil?
  BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Add Chef Status.
  def makeChef
    update_attribute(:chef,    true)
  end

  # Remove Chef Status
  def removeChef
    update_attribute(:chef,    false)
  end

  # Send Chef confirmation email
  def send_chef_confirmation_email
    UserMailer.chef_confirmation(@user).deliver_now
  end

  # Send Chef notification of dismissal!
  def send_chef_notification_email
    UserMailer.chef_notification(@user).deliver_now
  end

  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Deactivates an account
  def deactivate
    update_attribute(:activated,    false)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sends deactivation email.
  def send_deactivation_email
    UserMailer.account_deactivation(self).deliver_now
  end
  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  


private
    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
    # Removes avatar
    def delete_avatar
      self.avatar = nil
    end
end
