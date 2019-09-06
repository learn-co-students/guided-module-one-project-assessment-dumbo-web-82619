class CreatePrograms < ActiveRecord::Migration[5.2]
  def change
    create_table :programs do |t|
      t.string :name
      t.integer :gym_id
      t.string :category
      t.string :description
    end
  end
end
