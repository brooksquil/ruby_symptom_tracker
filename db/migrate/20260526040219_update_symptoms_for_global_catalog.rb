class UpdateSymptomsForGlobalCatalog < ActiveRecord::Migration[8.1]
  def change
    change_column_null :symptoms, :user_id, true
    add_column :symptoms, :normalized_name, :string
    add_index :symptoms, :normalized_name,
      unique: true,
      where: "user_id IS NULL",
      name: "index_global_symptoms_on_normalized_name"
    add_index :symptoms, [:user_id, :normalized_name],
      unique: true,
      where: "user_id IS NOT NULL",
      name: "index_user_symptoms_on_user_and_normalized_name"
  end
end
