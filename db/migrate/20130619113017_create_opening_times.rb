class CreateOpeningTimes < ActiveRecord::Migration[4.2]
  def change
    create_table :opening_times do |t|
      t.references :point_of_sale
      t.integer :day
      t.string :from
      t.string :to

      t.timestamps
    end
    add_index :opening_times, :point_of_sale_id
  end
end
