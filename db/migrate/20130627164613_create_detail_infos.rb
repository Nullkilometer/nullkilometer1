class CreateDetailInfos < ActiveRecord::Migration[4.2]
  def change
    create_table :detail_infos do |t|
      t.string :website
      t.string :mail
      t.string :phone
      t.string :cell_phone
      t.text :description
      t.references :detailable, polymorphic: true

      t.timestamps
    end
  end
end
