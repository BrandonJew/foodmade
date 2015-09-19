class ReservationsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  protect_from_forgery except: [:hook]

  def hook
    params.permit! # Permit all Paypal input params
    status = params[:payment_status]
    if status == "Completed"
      @reservation = Reservation.find(params[:invoice])
      @reservation.update_attributes(status: status, transaction_id: params[:txn_id], purchased_at: Time.now, paid: true)
      @reservation.send_reservation(current_user, @reservation.user_id)
      recipient = User.find(@reservation.user_id)
      flash[:success] = "Reservation request sent to #{recipient.name}"
      redirect_to "/users/#{@reservation.user_id}"
    else
      redirect_to "/dashboard"
    end
  end
 require 'paypal-sdk-rest'
include PayPal::SDK::REST
 def confirm_reservation
    @reservation = Reservation.find(params[:id])
    @reservation.update_attributes(confimation: true)
    amount = 0.9 * @reservation.price
    @payout = Payout.new(
  {
    :sender_batch_header => {
      :sender_batch_id => SecureRandom.hex(8),
      :email_subject => 'Payment for reservation!',
    },
    :items => [
      {
        :recipient_type => 'EMAIL',
        :amount => {
          :value => "#{amount}",
          :currency => 'USD'
        },
        :note => "You have a confirmed reservation at #{@reservation.time}. Thanks for your patronage!",
        :receiver => "chef@zmedia.com",
        :sender_item_id => "#{@reservation.id}",
      }
    ]
  }
)
  redirect_to "/dashboard?approved=true"
  flash[:success] = "Reservation confirmed. Message with details sent to customer."
#:receiver => "#{User.find(self.user_id).email}",
  end

  def deny_reservation
    @reservation = Reservation.find(params[:id])
    #@reservation.update_attributes(confimation: false)
    @payout = Payout.new(
      {
    :sender_batch_header => {
      :sender_batch_id => SecureRandom.hex(8),
      :email_subject => 'Payment for reservation!',
    },
    :items => [
      {
        :recipient_type => 'EMAIL',
        :amount => {
          :value => "#{@reservation.price}",
          :currency => 'USD'
        },
        :note => "You have a confirmed reservation at #{@reservation.time}. Thanks for your patronage!",
        :receiver => "chef@zmedia.com",
        :sender_item_id => "#{@reservation.id}",
      }
    ]
  }
)
  Reservation.find(params[:id]).destroy 
  redirect_to "/dashboard?approved=false"
  flash[:success] = "Reservation denied"
#:receiver => "#{User.find(@reservation.sender_id).email}",
   end

  def index
    @reservations = Reservation.where(user_id: current_user.id, paid: true)
  end 

  def create
    
    @reservation = Reservation.new(reservation_params)
    if @reservation.save
      redirect_to @reservation.paypal_url(reservation_path(@reservation))
    else
      redirect_to(:back)
      flash[:danger] = "Error in reservation form"
     # @reservation.send_reservation(current_user, @reservation.user_id)
      #flash[:success] = "Reservation request sent to #{recipient.name}"
     # redirect_to "/dashboard"
    end
  end
  def destroy
    Reservation.find(params[:id]).destroy
  end
  def show
   @reservation = Reservation.find(params[:id])
  end


private

  def reservation_params
    params.require(:reservation).permit(:time, :order, :price, :user_id)
  end
end
