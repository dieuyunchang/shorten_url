class ShortenedUrl < ApplicationRecord
  ORIGINAL_VALID_URL_FORMAT = /\A(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@,!:%_\+.~#?&\/\/=]*)?\z/

  validates :original_url, presence: true
  validates :original_url, format: {with: ORIGINAL_VALID_URL_FORMAT}, if: :original_url_exist?
  validates :sanitize_url, presence: true

  private

  def original_url_exist?
    original_url.present?
  end
end
