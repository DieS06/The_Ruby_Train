class RolesController < ApplicationController
  before_action :set_user

  def assign_role
    @user.add_role(params[:role])
    render json: { message: "Role assigned succesfully!" }
  end

  def remove_role
    @user.remove_role(params[:role])
    render json: { message: "Role removed succesfully!" }
  end

  def index
    render json: {roles: @user.roles.pluck(:name) }
  end

  private

  def set_user
     @user = User.find(params[:user_id])
  end
end
