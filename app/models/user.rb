class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true

  belongs_to :submitted_urls,
    primary_key: :user_id,
    foreign_key: :id,
    class_name: :ShortenedUrl

  belongs_to :visits,
    primary_key: :user_id,
    foreign_key: :id,
    class_name: :Visit

  has_many :visited_urls,
    through: :visits,
    source: :short_urls
end
