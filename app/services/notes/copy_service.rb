module Notes
  class CopyService
    attr_reader :note

    def initialize(note, user)
      @old_note = note
      @user = user
      @old_link = Link.new # this prevents nil error
    end

    def copy
      @note = @old_note.dup
      parse_link if @old_note.link
      @note.update_attributes(user: @user, public: false)
      create_log
      @note
    end

    private

    def create_log
      CopyServiceLogger.new(@old_note.user, @user, @old_note, @old_link).save
    end

    def parse_link
      @old_link = @old_note.link
      @link = @old_link.dup
      @link.update_attributes(user: @user)
      @note.update_attributes(link: @link)
    end
  end

  class CopyServiceLogger
    def initialize(from, to, note, link)
      @from = from
      @to = to
      @note = note
      @link = link
    end

    def save
      CopiedNote.create(from: @from, to: @to, note: @note, link: @link)
    end
  end
end
