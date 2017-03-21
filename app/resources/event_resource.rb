class EventResource < JSONAPI::Resource
  attributes :title, :description, :free, :start_time, :end_time, :event_type, :website

  relationship :location, to: :one
  relationship :contact, to: :one

  def start_time
    @model.start_at.to_i
  end

  def start_time=(start_at)
    @model.start_at = DateTime.strptime(start_at, "%s")
  end

  def end_time=(end_at)
    @model.end_at = DateTime.strptime(end_at, "%s")
  end
  
  def end_time
    @model.end_at.to_i
  end
end
