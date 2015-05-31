class AddStubIndexToMessages < ActiveRecord::Migration
  def change
    add_index :messages, :stub
  end
end
