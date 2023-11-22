class AddSanitizeUrlIntoShortenedUrls < ActiveRecord::Migration[7.1]
  def change
    add_column :shortened_urls, :sanitize_url, :string
  end
end
