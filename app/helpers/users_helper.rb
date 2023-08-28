module UsersHelper
  # Returns the Gravatar for the given user.
  def gravatar_for user, size: 80
    gravatar_id  = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def load_following
    current_user.active_relationships.find_by(followed_id: @user.id)
  end
end
