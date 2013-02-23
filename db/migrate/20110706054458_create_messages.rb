class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.binary :body
      t.string :stub
      t.datetime :expires_at
      t.datetime :read_at
      t.string :sender_email
      t.string :sender_ip
      t.string :recipient_email
      t.string :recipient_ip

      t.timestamps
    end
  end
end
