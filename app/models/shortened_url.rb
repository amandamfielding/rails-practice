require 'securerandom'

class ShortenedUrl < ActiveRecord::Base
  include SecureRandom
  validates :short_url, presence: true, uniqueness: true
  validates :user_id, presence: true
  validates :long_url, presence: true, length:{maximum: 1024}
  validate :no_more_than_five_per_min_by_one_user

  has_one :submitter,
    primary_key: :user_id,
    foreign_key: :id,
    class_name: :User

  belongs_to :visits,
  primary_key: :shortened_url_id,
  foreign_key: :id,
  class_name: :Visit

  has_many :visitors,
  Proc.new { distinct },
    through: :visits,
    source: :users

  has_many :tags,
    primary_key: :id,
    foreign_key: :short_url_id,
    class_name: :Tagging

  has_many :topics,
      through: :tags,
      source: :topic

  def self.random_code
    random = SecureRandom.urlsafe_base64(8)

    until !exists?(:short_url => random)
      random = SecureRandom.urlsafe_base64(8)
    end

    random
  end

  def self.create_for_user_and_long_url!(user, long_url)
    random = ShortenedUrl.random_code
    ShortenedUrl.create!(long_url: long_url,short_url:random,user_id:user.id)
  end

  def num_clicks
    Visit.where("shortened_url_id = ?",self.id).count
  end

  def num_uniques
    Visit.where("shortened_url_id = ?",self.id).count
  end

  def num_recent_uniques
    Visit.where("shortened_url_id = ? AND created_at > ?",self.id,10.minutes.ago).group(:user_id).count.keys.length
  end

  def no_more_than_five_per_min_by_one_user
    recent_urls = ShortenedUrl.where("created_at > ?",1.minutes.ago).group(:user_id).count
    if recent_urls.any? {|k,v| v > 5 && !User.find(k).premium}
      errors[:limit] << "can't submit that many URLs silly"
    end
  end
end
