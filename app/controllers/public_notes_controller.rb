class PublicNotesController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    @notes = Note.all_public_desc
    render_layout('detail', @notes)
  end
end
