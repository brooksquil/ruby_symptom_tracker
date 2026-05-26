class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  before_action :set_time_zones, only: %i[profile update_profile]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to new_session_path, notice: "User created successfully. Please sign in."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def profile
    @user = current_user
  end

  def update_profile
    @user = current_user

    if @user.update(profile_params)
      redirect_to profile_path, notice: "Profile updated successfully."
    else
      render :profile, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end

  def profile_params
    params.require(:user).permit(:time_zone)
  end

  def set_time_zones
    @time_zones = ActiveSupport::TimeZone.all.map { |tz| [tz.name, tz.name] }
  end
end
