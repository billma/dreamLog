OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,'245869448763506' ,'78af3a13dc16b62fa5be02ab1618730a' 
end
