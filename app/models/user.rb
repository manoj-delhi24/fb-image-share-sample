class User < ActiveRecord::Base
  attr_accessible :email, :name, :images_attributes

  has_many :authentications, :dependent => :delete_all
  has_many :images, :dependent => :destroy

  accepts_nested_attributes_for :images,
    :reject_if => lambda { |e| e[:photo].blank? && e[:description].blank?},
    :allow_destroy => true

  # apply omniauth currently for facebook only
  def apply_omniauth(omniauth)
    case omniauth['provider']
      when 'facebook'
        self.apply_facebook(omniauth)
    end
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'], :token =>(omniauth['credentials']['token'] rescue nil))
 end

  # generate facebook user using authentication token
  def facebook
    @fb_user ||= FbGraph::User.me( self.authentications.find_by_provider('facebook').token)
  end

  # fetch image and post it to current users facebook timeline with message
  def post_image_on_timeline( _image_id = '')
    unless( _image_id.blank?)
      _image = self.images.find( _image_id)
      _my_fb = self.facebook.fetch
      _my_fb.photo!( :source => File.new( _image.photo.path), :message => _image.description)
      true
    else
      false
    end
  end


  protected

  # set email from current users faceook email
  def apply_facebook(omniauth)
    if (info = omniauth['info'] rescue false)
      self.email = (info['email'] rescue '')
    end
  end

end