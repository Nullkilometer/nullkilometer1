class AddImageToDetailInfos < ActiveRecord::Migration
  def change
    add_column :detail_infos, :image, :string
  end
end
