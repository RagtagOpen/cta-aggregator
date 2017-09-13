class Event < ApplicationRecord

  attr_accessor :identifier

  serialize :identifiers, Array

  belongs_to :location, optional: true
  belongs_to :user, optional: true

  scope :upcoming, -> { where("start_date >= ?", Date.today).order("start_date") }
  scope :past, -> { where("start_date <= ?", Date.today).order("start_date") }

  validate :validate_uniqueness, on: [:create, :update]

  validates :title, :browser_url, :origin_system, :start_date,
    presence: true

  validates :free,
    inclusion: { in: [true, false, nil] }

  after_create :set_identifiers

  private

    def validate_uniqueness
      preexisting_event = Event.where(
        title: title,
        browser_url: browser_url,
        location_id: location_id
      ).first

      errors.add(:event, 'already exists') if preexisting_event
    end

    def set_identifiers
      self.identifiers << "cta-aggregator:#{id}"
      self.save(validate: false)
    end

end
