class CreatePlaceFeatures < ActiveRecord::Migration[4.2]
  def change
    create_table :place_features do |t|
      t.string :name
    end
  end
end
