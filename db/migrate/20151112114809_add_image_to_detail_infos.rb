class AddImageToDetailInfos < ActiveRecord::Migration[4.2]
  def change
    add_column :detail_infos, :image, :string
  end
end
