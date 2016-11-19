class RemoveUnsedFields < ActiveRecord::Migration[5.0]
  def change
    remove_column :profiles, :email, :string
    remove_column :organizations, :email, :string
  end
end
