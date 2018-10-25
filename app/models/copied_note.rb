class CopiedNote < ActiveRecord::Base
  composed_of :from,
              class_name: 'User',
              mapping: %w[from_user_id id],
              constructor: proc { |id| User.find(id) if id }
  composed_of :to,
              class_name: 'User',
              mapping: %w[to_user_id id],
              constructor: proc { |id| User.find(id) if id }
  composed_of :note,
              class_name: 'Note',
              mapping: %w[note_id id],
              constructor: proc { |id| Note.find(id) if id }
  composed_of :link,
              class_name: 'Link',
              mapping: %w[link_id id],
              constructor: proc { |id| Link.find(id) if id }
end
