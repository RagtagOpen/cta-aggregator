class CallToAction < ApplicationRecord
  CTA_TYPES = { onsite: 1, phone: 2 }

  has_many :call_to_action_contacts
  has_many :contacts, through: :call_to_action_contacts

  belongs_to :location, optional: true

  validates_presence_of :title, :description, :website, :start_at, :end_at, :event_type
  validate :validate_unique_call_to_action, on: :create

  attr_accessor :event_type

  def event_type=(event)
    self.action_type = CTA_TYPES[event.to_sym]
  end

  def event_type
    CTA_TYPES.invert[action_type]
  end

  private

  def validate_unique_call_to_action
    preexisting_cta = self.class.where(
      title: self.title,
      description: self.description,
      website: self.website,
      action_type: self.action_type,
      start_at: self.start_at,
      end_at: self.end_at
    ).first
    errors.add(:call_to_action, 'already exists') if preexisting_cta
  end
end
