class CreateDoctors < ActiveRecord::Migration[7.0]
  def change
    create_table :doctors do |t|
      t.string :name
      t.string :city
      t.string :specialization
      t.integer :cost_per_day
      t.text :description

      t.timestamps
    end
  end
end
