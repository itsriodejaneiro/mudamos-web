PAPERCLIP_BASIC_DEFAULTS = {
  :path => "uploads/#{Rails.env}/:class/:id/:attachment/:style.:extension",
  # :compression => {
  #   # :png => '-optimize',
  #   :jpeg => '-optimize'
  # },
  convert_options: { all: "-quality 75 -strip" }
}

PAPERCLIP_FOG_DEFAULTS = {
  storage: :fog,
  fog_credentials: {
    aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    provider: ENV['FOG_PROVIDER'],
    region: ENV['AWS_REGION'],
    scheme: 'https',
    path_style: true
  },
  fog_directory: ENV['AWS_BUCKET_NAME'],
  fog_file: {
    'Cache-Control' => 'max-age=315576000',
    'Expires' => 10.years.from_now.httpdate
  }
}

Paperclip::Attachment.default_options.merge! PAPERCLIP_BASIC_DEFAULTS

unless Rails.env.test?
  Paperclip::Attachment.default_options.merge! PAPERCLIP_FOG_DEFAULTS
end
