class User < ActiveRecord::Base
  has_and_belongs_to_many :events
  authenticates_with_sorcery!

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, :on => :create
  validates_confirmation_of :password

  def name_or_email
    name.present? ? name : email
  end
end
