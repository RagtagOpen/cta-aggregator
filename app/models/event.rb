class Event < ApplicationRecord

  belongs_to :location
  belongs_to :user, optional: true

  scope :upcoming, -> { where("start_date >= ?", Date.today).order("start_date")  }

  validate :validate_uniqueness, on: [:create, :update]

  validates :title, :description, :browser_url, :origin_system,
    :start_date, :end_date, :location_id,
    presence: true

  validates :free,
    inclusion: { in: [true, false] }

  private

    def validate_uniqueness
      preexisting_event = Event.where(
        title: title,
        browser_url: browser_url,
        location_id: location_id
      ).first

      errors.add(:event, 'already exists') if preexisting_event
    end

end
