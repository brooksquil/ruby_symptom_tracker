class CreateUserDiagnoses < ActiveRecord::Migration[8.1]
  def change
    create_table :user_diagnoses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :diagnosis, null: false, foreign_key: true
      t.date :diagnosed_on
      t.text :notes

      t.timestamps
    end
  end
end
