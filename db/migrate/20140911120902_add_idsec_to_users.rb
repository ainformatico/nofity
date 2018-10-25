class AddIdsecToUsers < ActiveRecord::Migration
  def change
    add_column :users, :idsec, :string
  end
end
