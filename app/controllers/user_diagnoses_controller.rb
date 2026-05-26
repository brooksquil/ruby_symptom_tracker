class UserDiagnosesController < ApplicationController
  before_action :set_user_diagnosis, only: %i[edit update destroy]

  def create
    @user_diagnosis = current_user.user_diagnoses.build(user_diagnosis_params)

    if @user_diagnosis.save
      redirect_to diagnoses_path, notice: "#{@user_diagnosis.diagnosis.name} added to your diagnoses."
    else
      redirect_to diagnoses_path, alert: user_diagnosis_error_message(@user_diagnosis)
    end
  end

  def edit
  end

  def update
    if @user_diagnosis.update(user_diagnosis_params)
      redirect_to diagnoses_path, notice: "#{@user_diagnosis.diagnosis.name} updated."
    else
      flash.now[:alert] = user_diagnosis_error_message(@user_diagnosis)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    diagnosis_name = @user_diagnosis.diagnosis.name
    @user_diagnosis.destroy
    redirect_to diagnoses_path, notice: "#{diagnosis_name} removed from your diagnoses."
  end

  private

  def set_user_diagnosis
    @user_diagnosis = current_user.user_diagnoses.find(params[:id])
  end

  def user_diagnosis_params
    params.require(:user_diagnosis).permit(:diagnosis_id, :diagnosed_on, :notes)
  end

  def user_diagnosis_error_message(user_diagnosis)
    diagnosis_name = user_diagnosis.diagnosis&.name.presence || "Diagnosis"

    if user_diagnosis.errors.attribute_names.intersect?(%i[diagnosis_id diagnosis])
      "#{diagnosis_name} already exists or is invalid."
    else
      user_diagnosis.errors.full_messages.to_sentence
    end
  end
end
