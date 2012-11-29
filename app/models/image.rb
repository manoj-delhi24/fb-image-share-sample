class Image < ActiveRecord::Base
  attr_accessible :description, :photo, :category_id

  belongs_to :user
  belongs_to :category

  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  validates :photo, :attachment_presence => true

  # list of images uploaded in last month
  scope :last_month_uploads, ( lambda do
    _month_starting = Date.current.at_beginning_of_month
     where( 'created_at > ? AND created_at < ?',
            _month_starting.advance(:months => -1).to_datetime,
            _month_starting.to_datetime
          )
   end)

  # average number of images uploaded by users in current month
  def self.avg_uploads_of_current_moonth
    where('created_at > ?', Date.current.at_beginning_of_month.to_datetime).count / User.count
  end
end
