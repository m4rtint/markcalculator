Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["415993921311-6pkh6n5cgeqnpol25nrgt9nqc8but26u.apps.googleusercontent.com"], ENV["4GGlkUpExVXJyB19EtHGePzX"]
end
