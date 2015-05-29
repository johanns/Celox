class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.string :stub
      t.datetime :expires_at

      t.timestamps
    end
  end
end
