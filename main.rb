require_relative './worker'

website_urls = ARGV.dup
collect_metadata = website_urls.delete('--metadata')

if website_urls.empty?
  puts 'Usage: ruby worker.rb [--metadata] <website1> <website2> ...'
  exit
end

worker = Worker.new(website_urls)
if collect_metadata
  puts "Meta data for the provided urls if already fetched: \n"
  puts worker.fetch_metadata
else
  worker.fetch_content
  puts 'Webpages fetched and saved!'
end

puts worker.errors if worker.errors.any?
