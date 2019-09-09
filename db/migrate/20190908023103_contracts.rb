class Contracts < ActiveRecord::Migration[5.2]
  def change
    create_table "contracts" do |t|
      t.integer :contractor_id
      t.integer :freelancer_id
      t.string :description
      t.integer :pay_out
      t.string :start_date
    end
  end
end
