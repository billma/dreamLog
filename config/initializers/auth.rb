require 'yaml'

OmniAuth.config.logger = Rails.logger

key= File.join(Rails.root,'config','keys.yml')
env= YAML.load_file(key)[Rails.env]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,env['appID'] ,env['secret'] 
end
