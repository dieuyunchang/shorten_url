FactoryBot.define do
  factory :shortened_url do
    original_url { "https://www.google.com/" }
    sanitize_url { "https://www.google.com/" }
  end
end
