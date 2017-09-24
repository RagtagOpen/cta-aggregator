require 'rails_helper'

describe GoogleSheet do
  let(:session_mock) { instance_double(GoogleDrive::Session) }
  let(:spreadsheet_mock) { instance_double(GoogleDrive::Spreadsheet) }

  before do
    allow(GoogleDrive::Session).
      to receive(:from_service_account_key).
      and_return(session_mock)
  end

  describe "#load_sheet" do
    it "returns the Google spreadsheet" do
      expect(session_mock).
        to receive(:spreadsheet_by_key).
        with("test").
        and_return(spreadsheet_mock)

      service = GoogleSheet.new(key: "test")
      spreadsheet = service.load_sheet

      expect(spreadsheet).to eq(spreadsheet_mock)
    end
  end
end
