class RecipientsController < ApplicationController

  def new
    @recipient = Recipient.new
  end
  def create
    @recipient = Recipient.new(recipient_params)
    if @recipient.save
      flash[:success] = "Success! You'll recieve updates about our progress in the future!"
      redirect_to ''
    else
      render 'new'
    end
  end
  
  def destroy
    @recipient.destroy
  end

  private
    def recipient_params
      params.require(:recipient).permit(:name, :email, :zipcode)
    end
    def set_recipient
      @recipient = Recipient.find(params[:id])
    end
end