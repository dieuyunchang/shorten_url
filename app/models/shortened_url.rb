class ShortenedUrl < ApplicationRecord
  UNIQUE_ID_LENGTH = 6
  ORIGINAL_VALID_URL_FORMAT = /\A(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@,!:%_\+.~#?&\/\/=]*)?\z/

  validates :original_url, presence: true, on: :create
  validates :original_url, format: {with: ORIGINAL_VALID_URL_FORMAT}, if: original_url.present?
  
end
