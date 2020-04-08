class Contractors < ActiveRecord::Migration[5.2]
  def change
    create_table "contractors" do |t|
      t.string :name
      t.string :company_name
      t.string :feilds
      t.string :bio
    end
  end
end
