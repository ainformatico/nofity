class User < ActiveRecord::Base
  include Idsec

  # Include default devise modules. Others available are:
  # :confirmable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :rememberable,
         :trackable,
         :validatable,
         :lockable,
         # :confirmable,
         :recoverable,
         :invitable,
         :async

  has_many :notes
  has_many :categories
  has_many :links

  # after_invitation_accepted :force_confirm

  # validates :username, presence: true
  # validates :username, uniqueness: true

  # User is not valid until the invitaiton is accepted.
  # This prevents creating and invitation and changing password
  # using the recover password feature without accepting the invitation.
  def send_reset_password_instructions
    super if invitation_token.nil?
  end

  # Set user as confirmed. Confirms email.
  def force_confirm
    confirm!
  end
end
