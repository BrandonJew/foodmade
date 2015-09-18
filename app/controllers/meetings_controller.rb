class MeetingsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @meeting = Meeting.new(meeting_params)
    if @meeting.save
       redirect_to "/users/#{current_user.id}/edit"
       flash[:success] = "#{@meeting.time} added to schedule!"
    else
       redirect_to "/users/#{current_user.id}/edit"
       flash[:danger] = "Error in time submission."
    end
  end

  def destroy
    Meeting.find(params[:id]).destroy
    redirect_to "/users/#{current_user.id}"
  end
  def show
   @meeting = Meeting.find(params[:id])
  end
  def index
    @meetings = Meeting.where(user_id: current_user.id)
  end 
  def update
    @meeting = Meeting.find(params[:id])
    if @meeting.destroy
      redirect_to "/users/#{current_user.id}"
    else
      redirect_to "/users/#{current_user.id}"
    end
  end

private

  def meeting_params
    params.require(:meeting).permit(:time, :user_id, :duration)
  end
end
