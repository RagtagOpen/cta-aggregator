require 'rails_helper'

describe ManualInputSheet do
  let(:session_mock) { instance_double(GoogleDrive::Session) }
  let(:spreadsheet_double) { instance_double(GoogleDrive::Spreadsheet) }
  let(:worksheet_double) { instance_double(GoogleDrive::Worksheet) }
  let(:test_row) { ["Alex", "", "9/24/2017", "", "", "Test Campaign"] }

  before do
    allow(GoogleDrive::Session).
      to receive(:from_service_account_key).
      and_return(session_mock)
  end

  describe "#rows" do
    it "returns the rows of the Google spreadsheet" do
      expect(session_mock).
        to receive(:spreadsheet_by_key).
        with(ManualInputSheet::SHEET_ID).
        and_return(spreadsheet_double)
      expect(spreadsheet_double).
        to receive(:worksheets).
        and_return([worksheet_double])
      expect(worksheet_double).
        to receive(:rows).
        and_return([test_row])

      subject = ManualInputSheet.new
      subject.load_sheet

      expect(subject.rows).to eq([test_row])
    end
  end
end
