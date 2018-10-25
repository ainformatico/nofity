json.cache! category do
  json.call(category, :name)
  json.id category.idsec
  json.total_notes category.notes.count
end
