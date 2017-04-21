class AddUserIdToCtas < ActiveRecord::Migration[5.0]
  def change
    add_reference :ctas, :user, foreign_key: true, type: :uuid, index: true
  end
end
