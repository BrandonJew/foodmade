class Meeting < ActiveRecord::Base
  belongs_to :user
  validates :time, presence: true
  validates :duration, presence: true

 def description
   "#{time} (#{duration} min)"
 end
end
