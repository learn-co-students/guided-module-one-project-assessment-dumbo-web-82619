class CreateRegistrations < ActiveRecord::Migration[5.2]
  def change
    create_table :registrations do |t|
      t.integer :user_id
      t.integer :gym_id
      t.string :start_date
      t.string :status
    end
  end
end
