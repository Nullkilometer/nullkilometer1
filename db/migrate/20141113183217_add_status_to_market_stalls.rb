class AddStatusToMarketStalls < ActiveRecord::Migration[4.2]
  def change
    add_column :market_stalls, :status_id, :integer
  end
end
