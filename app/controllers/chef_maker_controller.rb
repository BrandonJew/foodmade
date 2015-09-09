class ChefMakerController < ApplicationController
  def edit
    @user = User.find_by(email: params[:email])
    if !@user.chef?
      @user.makeChef
      flash[:success] = "#{@user.name} is now a chef! Notification email has been sent to #{@user.email}!" 
      @user.send_chef_confirmation_email
      redirect_to users_url
    else 
      @user.removeChef
      flash[:danger] = "#{@user.name} is no longer a chef. Notification email has been sent to #{@user.email}!"
      @user.send_chef_notification_email
      redirect_to users_url
    end
  end
end
