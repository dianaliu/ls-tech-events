class User < ActiveRecord::Base
  has_and_belongs_to_many :events do
    def upcoming
      # Search through the end of each month since we send reminders at the beginning of the month
      where(:start_date => Date.today..3.months.from_now.end_of_month)
    end
  end

  authenticates_with_sorcery!

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, :on => :create
  validates_confirmation_of :password

  def to_param
    name.present? ? "#{id}-#{name.gsub(/[^0-9a-z]/i, '-')}" : "#{id}"
  end

  def name_or_email
    name.present? ? name : email
  end
end
