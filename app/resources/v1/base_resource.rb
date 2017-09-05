module V1
  class BaseResource < JSONAPI::Resource
    include JSONAPI::Authorization::PunditScopedResource
    abstract
  end
end
