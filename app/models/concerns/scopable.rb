# By default, Rails uses the record's id to determine to first and last.
# That's meaningless if ID is a UUID.  This module fixes that.
# However note that changing the default scope will have some side effects.
# e.g. multiple calls to order *add* new ordering conditions, they don't replace one that's already there

module Scopable
  extend ActiveSupport::Concern

  included do
    default_scope -> { order(:created_at) }
  end
end
