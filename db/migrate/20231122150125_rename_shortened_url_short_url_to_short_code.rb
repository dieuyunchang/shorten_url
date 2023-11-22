class RenameShortenedUrlShortUrlToShortCode < ActiveRecord::Migration[7.1]
  def change
    rename_column :shortened_urls, :short_url, :short_code
  end
end
