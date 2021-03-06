class User < ApplicationRecord
  has_secure_password
  has_many :user_events, dependent: :destroy
  has_many :events, through: :user_events
  has_many :comments, dependent: :destroy


  EMAIL_REGEX = /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/

  validates :first_name, :last_name, presence: true, length: {in: 2..30}
  validates :email, presence: true, uniqueness: true, format: EMAIL_REGEX
  validates :password, confirmation: true
  validates_length_of :password, in: 6..20, on: :create
end
