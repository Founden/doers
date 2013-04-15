# Support for basic Gravatar functions
module GravatarHelper
  DEFAULT_OPTIONS = {:size => 60, :class => 'gravatar'}

  # Generates a Gravatar URI
  def gravatar_uri(email, options={})
    options = DEFAULT_OPTIONS.clone.update(options)
    options[:hash] = Digest::MD5.hexdigest(email)
    return '//www.gravatar.com/avatar/%{hash}?s=%{size}' % options
  end

  # Generates an image tag with a Gravatar URI
  def gravatar_tag(email, options)
    options = DEFAULT_OPTIONS.clone.update(options)
    return image_tag(gravatar_uri(email, options), options)
  end
end
