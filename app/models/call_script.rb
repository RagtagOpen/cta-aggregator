class CallScript < ApplicationRecord

  has_many :events
before_validation :add_or_update_checksum

  validates_presence_of :text
  validate :unique_text

  private

  def add_or_update_checksum
    return unless self.text # avoid triggering error on CallScript.new.valid?
    checksum = Digest::SHA2.hexdigest(self.text)
    self.checksum = checksum unless self.checksum == checksum
  end

  def unique_text
    preexisting_text = self.class.where(checksum: self.checksum).first
    errors.add(:call_script, "already exists.  Use call script with uuid #{preexisting_text.id}") if preexisting_text
  end
end
