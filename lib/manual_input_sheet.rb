class ManualInputSheet < GoogleSheet
  SHEET_ID = "16R7F6Y35M4Pe9FkcL51pbIiV-4ZkdXef9uZtVADszWY"

  def initialize
    super(key: SHEET_ID)
  end

  def rows
    worksheet.rows
  end

  private

  def worksheet
    sheet.worksheets.first
  end
end
