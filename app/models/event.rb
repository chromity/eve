class Event < ApplicationRecord
  belongs_to :user, foreign_key: "host"
  has_many :user_events, dependent: :destroy
  has_many :users, through: :user_events
  has_many :comments, dependent: :destroy

  validates :name, :date, :location, :city, presence: true
  validates :date,  date: { after: Proc.new { Date.today }, message: 'must be after today' }, on: :create
end
