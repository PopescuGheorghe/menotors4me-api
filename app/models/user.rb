class User < ApplicationRecord
  include SharedMethods
  devise :database_authenticatable, :registerable, :validatable

  validates :email, :password, :password_confirmation, presence: true
  validates :email, uniqueness: true
  validates_format_of :email, with: Devise.email_regexp
  validates :auth_token, uniqueness: true, allow_nil: true

  has_one :mentor, dependent: :destroy, autosave: true
  has_one :organization, dependent: :destroy, autosave: true

  has_many :role_assignments, dependent: :destroy
  has_many :roles, through: :role_assignments

  accepts_nested_attributes_for :role_assignments, allow_destroy: true

  attr_accessor :role_id

  def assign_roles(role_ids)
    new_assignments = []
    Array(role_ids).each { |role_id| new_assignments << { role_id: role_id } }
    self.role_assignments_attributes = new_assignments
  end

  # Public: generates an authentication token
  # returns - token for the user
  def generate_authentication_token!
    loop do
      self.auth_token = Devise.friendly_token
      self.auth_token_created_at = Time.now
      break auth_token unless self.class.exists?(auth_token: auth_token)
    end
  end

  def admin?
    self.role?(CR::ADMIN)
  end

  def mentor?
    self.role?(CR::MENTOR)
  end

  def organization?
    self.role?(CR::ORGANIZATION)
  end

  # Public: models JSON representation of the object
  # _options - parameter that is provided by the standard method
  # returns - hash with user data
  def as_json(options = {})
    custom_response = {
      id: id,
      email: email,
      role:  roles.pluck(:slug)
    }

    add_mentor_data(custom_response) if mentor.present?
    add_skills_data(custom_response) if mentor.present? && mentor.skills.any?
    add_organization_data(custom_response) if organization .present?
    options.empty? ? custom_response : super
  end

  def deactivate
    update_attributes(active: false)
  end

  def activate
    update_attributes(active: true)
  end

  private

  def role?(slug)
    Role.list_by(:slug, roles).keys.include?(slug)
  end

  def add_mentor_data(response)
    response[:mentor_id] = mentor.id
    response[:first_name] = mentor.first_name
    response[:last_name] = mentor.last_name
    response[:phone_number] = mentor.phone_number
    response[:city] = mentor.city
    response[:description] = mentor.description
    response[:facebook] = mentor.facebook
    response[:linkedin] = mentor.linkedin
    response
  end

  def add_organization_data(response)
    response[:organization_id] = organization.id
    response[:name] = organization.name
    response[:asignee] = organization.asignee
    response[:phone_number] = organization.phone_number
    response[:city] = organization.city
    response[:description] = organization.description
    response
  end

  def add_skills_data(response)
    response[:skills] = mentor.skills.pluck(:name)
  end
end
