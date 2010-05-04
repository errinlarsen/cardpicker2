# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_cardpicker2_session',
  :secret      => '39448ec7280432ef01a35587d2f0a19e4cfcfb1bfc99f4e8667af1e1002cf90b295904dd30df4a32e42f493bd7edcc420d1dbeffadb1d8dd843b38017256694d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
