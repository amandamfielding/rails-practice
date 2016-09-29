class Tagging < ActiveRecord::Base
  validates :short_url_id, presence: true
  validates :tag_topic_id, presence: true

  belongs_to :url,
    primary_key: :id,
    foreign_key: :short_url_id,
    class_name: :ShortenedUrl

  belongs_to :topic,
    primary_key: :id,
    foreign_key: :tag_topic_id,
    class_name: :TagTopic
end
