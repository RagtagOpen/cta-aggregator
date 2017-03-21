class Event < ApplicationRecord
  CTA_TYPES = { onsite: 1, phone: 2 }

  belongs_to :contact, optional: true #maybe it shuldn't be opeiontal?
  belongs_to :location, optional: true

  validates_presence_of :title, :description, :website, :start_at, :end_at, :event_type
  validate :validate_unique_event, on: :create

  scope :upcoming, lambda { where("start_at >= ?", Date.today).order("start_at") }

  attr_accessor :event_type

  def event_type=(event)
    self.action_type = CTA_TYPES[event.to_sym]
  end

  def event_type
    CTA_TYPES.invert[action_type]
  end

  private

  def validate_unique_event
    preexisting_event = self.class.where(
      title: self.title,
      description: self.description,
      website: self.website,
      action_type: self.action_type,
      start_at: self.start_at,
      end_at: self.end_at
    ).first
    errors.add(:event, 'already exists') if preexisting_event
  end
end
