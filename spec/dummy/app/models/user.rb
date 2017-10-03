class User < ActiveRecord::Base
  scope :has_lastname, ->(name) { where(last_name: name) }
end
