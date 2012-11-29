class Category < ActiveRecord::Base
  attr_accessible :name

  has_many :images

  validates :name, :presence => true

  # generate options for category select box
  def self.select_options
    all.collect{ |e| [e.name, e.id]}
  end

  # count number of images in a category
  def number_of_images
    images.count
  end

  # count number of users who uploaded image in particular category
  def total_users
    users.count
  end

  # all users who uploaded images in a particular category
  def users
    category_users.uniq
  end

  # list of users, sorted by the number of images uploaded by users in that particular category
  def sorted_users
    _users_hash = Hash.new( 0)
    category_users.each{|_u| _users_hash[ _u] +=1 }
    _users_hash.sort {|u1,u2| u2[1] <=> u1[1]}.collect{|k,v| k}
  end

  # list of ids of all the users who uploaded images to a particular category
  def user_ids
    users.collect(&:id)
  end

  private
  # list of all images users
  def category_users
    images.collect{|e| e.user}
  end

end
