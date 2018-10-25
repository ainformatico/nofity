class NoteController < ApplicationController
  before_action :ensure_note, only: %i[update destroy edit]
  before_action :ensure_note_and_owner, only: %i[update destroy edit]

  skip_before_filter :authenticate_user!, only: [:show]

  def index
    @notes = Note.for_user(current_user)
  end

  def show
    if user_signed_in?
      @note = Note.private_or_public(current_user, params[:id])
    else
      @invitation_request = InvitationRequest.new
      @note = Note.public(params[:id])
    end
    render_layout('detail', @note)
  end

  def create
    data = parse_note

    @note = current_user.notes.create(data)
    render status: 400 unless @note
  end

  def edit
    render 'layouts/application'
  end

  def copy
    other_user_note = Note.public(copy_note_params[:id])
    @note = ::Notes::CopyService.new(other_user_note, current_user).copy
  end

  def update
    link = @note.link
    data = parse_note

    data[:link] = link unless data[:link]
    data[:content] = @note.content if data[:content].empty?

    @note.update_attributes(data)
  end

  def destroy
    @note.remove
  end

  private

  def ensure_note
    @note = Note.for_user(current_user, params[:id])
  end

  def ensure_note_and_owner
    # note not found and/or is not owned by the user
    render status: :not_found if @note.nil? || @note.user != current_user
  end

  def copy_note_params
    params.require(:note).permit(:id)
  end

  def note_params
    # NOTE: this allows to check strictly for params but not
    #       in the update action. This is because we can have an empty
    #       description, and if using PATCH then we get empty params.
    base = if params[:action] == 'update'
             params.fetch(:note, {})
           else
             params.require(:note)
           end

    base.permit(:content, :public, categories: %i[id name])
  end

  def parse_note_data(data)
    parser = ::Notes::ParserService.new(data).parse
    parser.to_hash
  end

  def note_data
    defaults = {
      user: current_user
    }
    data = note_params
    data.merge!(defaults)
  end

  def parse_note
    data = note_data
    data.merge! parse_note_data(data)
  end
end
