class CreateShortenedUrls < ActiveRecord::Migration
  def change
    create_table :shortened_urls do |t|
      t.string :long_url, null: false
      t.string :short_url, null: false, unique: true
      t.integer :user_id, null: false
    end
    add_index :shortened_urls, :short_url
    add_index :shortened_urls, :user_id
  end
end
