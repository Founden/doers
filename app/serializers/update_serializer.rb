# [Activity] model serializer to be sent as websocket payload
class UpdateSerializer < ActivitySerializer
  root :activity

  embed :ids, :include => true
  attributes :is_new

  # Mark activities sent as updates as new
  def is_new
    true
  end
end
