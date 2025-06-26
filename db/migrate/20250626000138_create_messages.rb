# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.string :stub, null: false
      t.string :body, null: false
      t.datetime :read_at
      t.datetime :expires_at

      t.timestamps
    end
    add_index :messages, :stub, unique: true
  end
end
