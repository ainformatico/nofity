class AddNoteIdToLink < ActiveRecord::Migration
  def change
    add_reference :links, :note, index: true
  end
end
