# [Faraday::Response] object serializer
class EmbedSerializer < ActiveModel::Serializer
  root :embed

  attributes :id, :title, :height, :width, :html, :type => :embed_type
  attributes :provider_name, :thumbnail_url, :author_url, :author_name
  attributes :url => :embed_url

  # Dummy ID to make Ember happy
  def id
    DateTime.now.to_i
  end

  # Overwrite serializer constructor
  def initialize(object, options={})
    object = OpenStruct.new object.body
    # Make [ActiveModel::Serializer] accept a [Faraday::Response] object
    object.send(:extend, ActiveModel::SerializerSupport)
    super(object, options)
  end

  # Underscore provider name to have a format for it
  def provider_name
    object.provider_name.to_s.underscore
  end
end
