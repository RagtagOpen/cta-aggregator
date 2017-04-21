class CTA < ApplicationRecord
  CTA_TYPES = { onsite: 1, phone: 2 }

  belongs_to :contact, optional: true
  belongs_to :location, optional: true
  belongs_to :call_script, optional: true
  belongs_to :user, optional: true

  validates_presence_of :title, :description, :website, :start_at, :cta_type
  validate :validate_unique_cta, on: :create

  scope :upcoming, -> { where("start_at >= ?", Date.today).order("start_at") }

  def cta_type=(cta_name)
    self.action_type = CTA_TYPES[cta_name.to_sym]
  end

  def cta_type
    CTA_TYPES.invert[action_type]
  end

  private

  def validate_unique_cta
    preexisting_cta = self.class.where(
      title: self.title,
      website: self.website,
      action_type: self.action_type,
      start_at: self.start_at
    ).first
    errors.add(:cta, 'already exists') if preexisting_cta
  end
end
