class ItemsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @item = Item.new(item_params)
    if @item.save
       redirect_to "/users/#{current_user.id}/edit"
       flash[:success] = "#{@item.name} added to menu!"
    else
             redirect_to "/users/#{current_user.id}/edit"
       flash[:danger] = "Error in menu item form."
    end
  end

  def destroy
    Item.find(params[:id]).destroy
    redirect_to "/users/#{current_user.id}"
  end
  def show
   @item = Item.find(params[:id])
  end
  def index
    @items = Item.where(user_id: current_user.id)
  end 
  def update
    @item = Item.find(params[:id])
    if @item.destroy
      redirect_to "/users/#{current_user.id}"
    else
      redirect_to "/users/#{current_user.id}"
    end
  end

private

  def item_params
    params.require(:item).permit(:name, :description, :price, :user_id, :avatar)
  end
end
