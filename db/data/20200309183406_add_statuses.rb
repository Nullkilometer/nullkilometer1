class AddStatuses < ActiveRecord::Migration[5.2]
  def up
    Status.create(name: 'approved')
    Status.create(name: 'pending')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
