class TagTopic < ActiveRecord::Base
  validates :topic, presence: true

  has_many :tags,
    primary_key: :id,
    foreign_key: :tag_topic_id,
    class_name: :Tagging

  has_many :urls,
      through: :tags,
      source: :url
end
