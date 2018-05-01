require 'vcr'

VCR.configure do |c|
  #the directory where your cassettes will be saved
  c.cassette_library_dir = 'spec/vcr'
  # your HTTP request service. You can also use fakeweb, webmock, and more
  c.hook_into :webmock
  c.filter_sensitive_data('<ENCODED AUTH HEADER>') { Base64.encode64("#{ENV.fetch('TODOABLE_USER')}:#{ENV.fetch('TODOABLE_PASSWORD')}").chomp }
end
