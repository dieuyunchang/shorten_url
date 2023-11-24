class RemoveShortenedUrlShortCode < ActiveRecord::Migration[7.1]
  def change
    remove_column :shortened_urls, :short_code
  end
end
