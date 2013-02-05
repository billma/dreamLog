class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.string :body
      t.integer :user_id
      t.integer :comment_id
      t.boolean :flag

      t.timestamps
    end
  end
end
