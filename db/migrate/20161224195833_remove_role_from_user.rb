# frozen_string_literal: true
class RemoveRoleFromUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :role, :string
  end
end
