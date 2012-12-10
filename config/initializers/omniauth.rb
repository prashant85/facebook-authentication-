Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,'412205342160168','199e23dbbdc66d2d6a593a64e3862500', {:client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}}
end