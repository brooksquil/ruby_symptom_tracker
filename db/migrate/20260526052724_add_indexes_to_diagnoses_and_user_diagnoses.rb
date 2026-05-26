class AddIndexesToDiagnosesAndUserDiagnoses < ActiveRecord::Migration[8.1]
  def change
    add_index :diagnoses, :normalized_name,
      unique: true,
      where: "user_id IS NULL",
      name: "index_global_diagnoses_on_normalized_name"

    add_index :diagnoses, [:user_id, :normalized_name],
      unique: true,
      where: "user_id IS NOT NULL",
      name: "index_user_diagnoses_on_user_and_normalized_name"

    add_index :user_diagnoses, [:user_id, :diagnosis_id],
      unique: true,
      name: "index_user_diagnoses_on_user_and_diagnosis"
  end
end