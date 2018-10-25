module NoteHelper
  def populate_description(note)
    return unless note

    if note.link
      note.link.title
    else
      note.content
    end
  end
end
