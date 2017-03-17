class CallToActionResource < JSONAPI::Resource
  attributes :title, :description, :free, :start_time, :end_time, :location, :contacts

  relationship :location, to: :one
  relationship :contacts, to: :many

  def location
    @model.location
  end

  def start_time
    @model.start_at.to_i
  end
  
  def end_time
    @model.end_at.to_i
  end
  
end
