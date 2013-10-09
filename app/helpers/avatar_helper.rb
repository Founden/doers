# Support for avatar with gravatar fallback
module AvatarHelper
  DEFAULT_OPTIONS = {:size => 60, :class => 'avatar'}

  # User avatar wrapper to serve Gravatar if an avatar is not uploaded
  def avatar_uri(user, options={})
    if user.avatar
      user.avatar.attachment.url(:thumb)
    else
      gravatar_uri(user.email, options)
    end
  end

  # Generates a Gravatar URI
  def gravatar_uri(email, options={})
    options = DEFAULT_OPTIONS.clone.update(options)
    options[:hash] = Digest::MD5.hexdigest(email)
    return '//www.gravatar.com/avatar/%{hash}?s=%{size}' % options
  end

  # Generates an image tag with a Gravatar URI
  def avatar_tag(user, options)
    options = DEFAULT_OPTIONS.clone.update(options)
    return image_tag(avatar_uri(user, options), options)
  end
end
