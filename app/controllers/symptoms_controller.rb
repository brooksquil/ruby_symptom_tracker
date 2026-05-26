class SymptomsController < ApplicationController
    before_action :set_symptom, only: %i[edit update destroy]
  
    def index
      @global_symptoms = Symptom.global.order(:name)
      @custom_symptoms = current_user.symptoms.order(:name)
    end
  
    def new
      @symptom = current_user.symptoms.build
    end
  
    def create
      @symptom = current_user.symptoms.build(symptom_params)
  
      if @symptom.save
        redirect_to symptoms_path, notice: "#{@symptom.name} added to your symptoms."
      else
        flash.now[:alert] = symptom_error_message(@symptom)
        render :new, status: :unprocessable_entity
      end
    end
  
    def edit
    end
  
    def update
      if @symptom.update(symptom_params)
        redirect_to symptoms_path, notice: "Symptom updated."
      else
        flash.now[:alert] = symptom_error_message(@symptom)
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @symptom.destroy
      redirect_to symptoms_path, notice: "Symptom removed."
    end
  
    private
  
    def set_symptom
      @symptom = current_user.symptoms.find(params[:id])
    end
  
    def symptom_params
      params.require(:symptom).permit(:name)
    end

    def symptom_error_message(symptom)
      if symptom.errors.attribute_names.intersect?(%i[name normalized_name])
        "#{symptom.name.presence || "Symptom"} already exists or is invalid."
      else
        symptom.errors.full_messages.to_sentence
      end
    end
  end