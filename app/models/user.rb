# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation

  has_secure_password

  # Make sure email addresses are ALL stored lower case as well as unique.
  before_save { email.downcase! }
  before_save :create_remember_token

  # the after_validation removes the cryptic "Password digest can't be blank" message
  # that will surely confuse users.  There is still a "Password can't be blank message"
  after_validation { self.errors.messages.delete(:password_digest) }

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
		    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
