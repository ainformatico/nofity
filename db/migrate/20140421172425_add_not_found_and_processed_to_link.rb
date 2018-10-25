class AddNotFoundAndProcessedToLink < ActiveRecord::Migration
  def change
    add_column :links, :not_found, :boolean, default: false
    add_column :links, :processed, :boolean, default: false
  end
end
