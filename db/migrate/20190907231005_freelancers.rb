class Freelancers < ActiveRecord::Migration[5.2]
  def change
    create_table "freelancers" do |t|
      t.string :name
      t.integer :age
      t.integer :dob
      t.string :certifications
    end
  end
end
