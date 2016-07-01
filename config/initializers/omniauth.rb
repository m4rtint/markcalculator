Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, "632755450214436", "965b702bd65111f492bab432dcc3ea33"
    provider :google_oauth2, '415993921311-1i7s3rbdj2qu2s6tv1rg61q7tuuibj1j.apps.googleusercontent.com', 'WZIHg-kSw0LG0CL6U3SePFnf', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end
