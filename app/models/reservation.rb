class Reservation < ActiveRecord::Base
  belongs_to :user
  
  scope :sent, -> {  where(:sent => true) }
  scope :received, -> { where(:sent => false)  }

  validates :time, presence: true
  validates :order, presence: true
  validates :price, presence: true


  def send_reservation(sender, recipient_id)
      self.update_attributes :user_id => sender.id, :sent => true, :sender_id => sender.id, :receiver_id => recipient_id
      msg = self.dup
      msg.update_attributes :user_id => recipient_id, :sent => false
      msg.save
     # msg = self.dup
    #self.update_attributes  :user_id => recipient.id, :sent => false
  end
  
 
  serialize :notification_params, Hash
  def paypal_url(return_path)
    values = {
        business: "thezmedia-facilitator@hotmail.com",
        cmd: "_xclick",
        upload: 1,
        return: "#{Rails.application.secrets.app_host}#{return_path}",
        invoice: self.id,
        amount: self.price,
        item_name: self.order,
        item_number: self.id,
        quantity: '1',
        notify_url: "#{Rails.application.secrets.app_host}/hook"
    }
    "#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?" + values.to_query
  end

  
end
