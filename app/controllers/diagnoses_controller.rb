class DiagnosesController < ApplicationController
  before_action :set_diagnosis, only: %i[edit update destroy]

  def index
    @global_diagnoses = Diagnosis.global.order(:name)
    @custom_diagnoses = current_user.diagnoses.order(:name)
    @user_diagnoses = current_user.user_diagnoses.includes(:diagnosis).sort_by { |user_diagnosis| user_diagnosis.diagnosis.name }
    @diagnosis = current_user.diagnoses.build
  end

  def new
    @diagnosis = current_user.diagnoses.build
  end

  def create
    @diagnosis = current_user.diagnoses.build(diagnosis_params)

    if @diagnosis.save
      current_user.user_diagnoses.find_or_create_by!(diagnosis: @diagnosis)
      redirect_to diagnoses_path, notice: "#{@diagnosis.name} added to your diagnoses."
    else
      flash.now[:alert] = diagnosis_error_message(@diagnosis)
      load_index_diagnoses
      render :index, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @diagnosis.update(diagnosis_params)
      redirect_to diagnoses_path, notice: "Diagnosis updated."
    else
      flash.now[:alert] = diagnosis_error_message(@diagnosis)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.user_diagnoses.where(diagnosis: @diagnosis).destroy_all
    @diagnosis.destroy
    redirect_to diagnoses_path, notice: "#{@diagnosis.name} removed from your diagnoses."
  end

  private

  def set_diagnosis
    @diagnosis = current_user.diagnoses.find(params[:id])
  end

  def diagnosis_params
    params.require(:diagnosis).permit(:name)
  end

  def diagnosis_error_message(diagnosis)
    if diagnosis.errors.attribute_names.intersect?(%i[name normalized_name])
      "#{diagnosis.name.presence || "Diagnosis"} already exists or is invalid."
    else
      diagnosis.errors.full_messages.to_sentence
    end
  end

  def load_index_diagnoses
    @global_diagnoses = Diagnosis.global.order(:name)
    @custom_diagnoses = current_user.diagnoses.order(:name)
    @user_diagnoses = current_user.user_diagnoses.includes(:diagnosis).sort_by { |user_diagnosis| user_diagnosis.diagnosis.name }
  end
end
