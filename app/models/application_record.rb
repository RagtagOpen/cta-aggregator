class ApplicationRecord < ActiveRecord::Base
  include Scopable
  self.abstract_class = true
end
