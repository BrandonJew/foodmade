class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy, :activationStatus, :chefStatus]
  # GET /users
  # GET /users.json
  #def index
 #   @users = User.where(admin: false).paginate(page: params[:page], :per_page => 15)
#  end
  
  def index
    if current_user.admin?
      @users = User.where(admin: false).paginate(page: params[:page], :per_page => 15)
    else
      @users = nearyou(params[:zip])
    end
  end
  
  def chefrequest
    sendchefrequest(params[:content])
  end

  def sendchefrequest (content)
    current_user.update_attributes(request: true, chef: true)
    user = User.first
    time = Time.new
    datestamp = time.strftime("%Y-%m-%d %l:%M %P")
    message = ("Sent from #{current_user.name} (#{current_user.email} | ID: #{current_user.id}) at #{datestamp}: \n" + "\n" + content) 
    user.messages.push(message)
    user.save
  end

  def sendmessage
      user = User.find(params[:id])
      messagesender(params[:content], user)
  end


 def messagesender (content, user)
    time = Time.new
    datestamp = time.strftime("%Y-%m-%d %l:%M %P")
    if !current_user.chef?
    message = ("Sent from #{current_user.name} (#{current_user.email}) at #{datestamp}: \n" + "\n" + content + "\n" + "\n Profile: foodmade.co/users/#{current_user.id}")
    else
    message = ("Sent from #{current_user.name} (Chef) at #{datestamp}: \n" + "\n" + content + "\n" + "\n Profile: foodmade.co/users/#{current_user.id}")
    end 
    user.messages.push(message)
    user.save
  end

  def nearyou (zip)

    @chefs = Array.new
    address = Geokit::Geocoders::GoogleGeocoder.geocode "#{zip}"
    @users = User.where(chef: true)
    @users.each do |user|
      if user.chef?
        destination = Geokit::Geocoders::GoogleGeocoder.geocode "#{user.zipcode}"
        if (destination.distance_to(address) < 30)
          @chefs.push(user)
        end
      end
    end
    return @chefs
  end



  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @items = Item.where(user_id: @user.id) 
    @meetings = Meeting.where(user_id: @user.id)
    @reservation = Reservation.create
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
	@user = User.find(params[:id])
        @item = Item.create
        @meeting = Meeting.create
  end
 

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      #@user.store_location
      @user.send_activation_email
      flash[:success] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      #@user.store_location
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  def activationStatus
    @user = User.find(params[:id])
    if !@user.activated?
      @user.activate
      flash[:success] = "#{@user.name} is now activated!" 
      redirect_to "/users?approved=true"
    else 
      @user.deactivate
      flash[:danger] = "#{@user.name} has been deactivated. Notification email has been sent to #{@user.email}!"
      @user.send_deactivation_email
      redirect_to "/users?approved=false"
    end
  end
  def chefStatus
    @user = User.find(params[:id])
    if !@user.chef?
      @user.update_attribute(:chef,    true)
      @user.update_attribute(:request, false)
      flash[:success] = "#{@user.name} is now a chef! Notification email has been sent to #{@user.email}!" 
      @user.messages.push("From the FoodMade Team: \n
      \n You are now a chef! Be sure to update your profile information with what you will cook!")
      @user.save
      UserMailer.chef_confirmation(@user).deliver_now
      redirect_to "/users?approved=true"
    else 
      @user.update_attribute(:chef,    false)
      flash[:danger] = "#{@user.name} is no longer a chef. Notification email has been sent to #{@user.email}!"
      UserMailer.chef_notification(@user).deliver_now
      redirect_to "/users?approved=false"
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
    end
  end




  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, :remove_avatar, :zipcode, :food, :messages, :menu, :request)
    end
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
end
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end


        

