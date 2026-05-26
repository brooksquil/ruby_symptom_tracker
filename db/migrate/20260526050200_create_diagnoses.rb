class CreateDiagnoses < ActiveRecord::Migration[8.1]
  def change
    create_table :diagnoses do |t|
      t.references :user, null: true, foreign_key: true
      t.string :name
      t.string :normalized_name

      t.timestamps
    end
  end
end
