class Visit < ActiveRecord::Base
  validates :user_id, presence: true
  validates :shortened_url_id, presence: true

  def self.record_visit!(user, shortened_url)
    Visit.create!(user_id: user.id, shortened_url_id: shortened_url.id)
  end

  has_many :users,
    primary_key: :user_id,
    foreign_key: :id,
    class_name: :User

  has_many :short_urls,
    primary_key: :shortened_url_id,
    foreign_key: :id,
    class_name: :ShortenedUrl
end
