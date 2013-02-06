class AddLogIdToComment < ActiveRecord::Migration
  def change
    add_column :comments, :log_id, :integer
  end
end
