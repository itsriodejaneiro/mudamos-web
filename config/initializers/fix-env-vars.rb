# Fix multiline private key when it's loaded using a json file
ENV["GOOGLE_PRIVATE_KEY"] = ENV["GOOGLE_PRIVATE_KEY"].gsub("\\n", "\n") if ENV["GOOGLE_PRIVATE_KEY"].present?
