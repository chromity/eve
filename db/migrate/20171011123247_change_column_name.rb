class ChangeColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :events, :user_id, :host
  end
end
