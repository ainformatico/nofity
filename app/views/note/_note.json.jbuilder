json.cache! note do
  if note
    json.call(note, :content, :public, :created_at)
    json.id note.idsec
    json.user note.user.idsec
    json.categories note.categories, partial: 'categories/category', as: :category
    json.link do
      if note.link
        json.partial! 'link/link', link: note.link
      else
        json.null!
      end
    end
  else
    json.id nil
  end
end
