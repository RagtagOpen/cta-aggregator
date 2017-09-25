class GoogleSheet
  def initialize(key:)
    @key = key
    @session = GoogleDrive::Session.from_service_account_key(auth_credentials)
  end

  def load_sheet
    @sheet = session.spreadsheet_by_key(key)
  end

  private

  attr_reader :key, :session, :sheet

  def auth_credentials
    StringIO.new(ENV['GOOGLE_APPLICATION_CREDENTIALS'])
  end
end
