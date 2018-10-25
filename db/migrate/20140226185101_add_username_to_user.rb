class AddUsernameToUser < ActiveRecord::Migration
  def change
    add_column :users, :username, :string, unique: true, null: true
  end
end
