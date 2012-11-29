Rails.application.config.middleware.use OmniAuth::Builder do
  # The following is for facebook
  provider :facebook, '479667642073050', 'f8f1a140a21ce8f3ad5b60407f48915c', { :scope => 'email, read_stream, read_friendlists, friends_likes, friends_status, offline_access, publish_stream'}
  #  you want to also configure for additional login services, they would be configured here.
end