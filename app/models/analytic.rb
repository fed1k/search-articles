class Analytic
  include Mongoid::Document
  include Mongoid::Timestamps
  field :ip, type: String
  field :searchQuery, type: String
end
