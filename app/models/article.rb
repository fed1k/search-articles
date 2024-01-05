class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  field :id, type: String
  field :article_name, type: String
end
