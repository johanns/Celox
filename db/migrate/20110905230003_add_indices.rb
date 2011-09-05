class AddIndices < ActiveRecord::Migration
  def change
  	add_index :messages, :stub, :unqiue => true
  end
end
