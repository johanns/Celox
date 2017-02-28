# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  body       :text
#  stub       :string
#  expires_at :datetime
#  created_at :datetime
#  updated_at :datetime
#  read_at    :datetime
#
# Indexes
#
#  index_messages_on_stub  (stub)
#

class Message < ActiveRecord::Base
  attr_reader :key

  validates :body, presence: true, length: { maximum: 4096 }
end
