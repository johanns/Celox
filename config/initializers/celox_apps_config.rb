# YOU MUST RESTART THE APPLICATION SERVER IF THIS FILE IS CHANGED.
#
# TODO: Replace constants with an elegant / flexible solution!
#
# Specify CIPHER to be used to encrypt the message in the Database
# Valid options are:
# aes-128-cbc
# aes-192-cbc
# aes-256-cbc
APP_CIPHER = 'aes-256-cbc'

# Specify the length of the 
APP_KEY_LENGTH = 12

# Specify the text used replace the encrypted message once it's read
APP_READ_MARKER = '!**READ**!'

# Keep a record of IP addresses (sender and reader) in the database
APP_TRACK_IP = false

# Remember to change this for production or your particular environment
if Rails.env == 'production'
  APP_URL = 'https://celox.me/'
else
  APP_URL = 'http://localhost:3000'
end

APP_FROM_ADDRESS = 'noreply@celox.me'