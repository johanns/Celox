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

require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
