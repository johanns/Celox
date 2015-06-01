require File.expand_path('../../../config/boot',        __FILE__)
require File.expand_path('../../../config/environment', __FILE__)
require 'clockwork'

include Clockwork

every(5.minutes, 'Message Clean-up') {
  MessagesCleanupJob.new.async.perform
}