require_relative './helpers/fetcher'
require_relative './helpers/error_handler'

class Worker
  include ErrorHandler

  attr_accessor :errors

  ROOT_DATA_PATH = './container/data/'.freeze
  META_DATA_FILE = ROOT_DATA_PATH + 'metadata.csv'.freeze

  def initialize(urls)
    @urls = urls
    @errors = []
  end

  def fetch_content
    error_handler_wrapper do
      metadatas = @urls.map do |url|
        fetcher = Fetcher.new(url, ROOT_DATA_PATH)
        success = fetcher.perform
        fetcher.metadata if success
      end

      save_metadata(metadatas.compact) if metadatas.any?
    end
  end

  def save_metadata(metadatas)
    data_array = metadatas.map(&:values)

    existing_urls = []
    if File.exist?(META_DATA_FILE)
      existing_urls = CSV.read(META_DATA_FILE, headers: true, converters: :all).map { |row| row['url'] }
    end

    filtered_data = data_array.reject { |row| existing_urls.include?(row[0]) }

    return unless filtered_data.any?

    csv_data = CSV.generate(headers: metadatas.first.keys, write_headers: !File.exist?(META_DATA_FILE)) do |csv|
      filtered_data.each do |row|
        csv << row
      end
    end

    File.open(META_DATA_FILE, 'a') do |file|
      file.write(csv_data)
    end
  end

  def fetch_metadata
    data = []
    error_handler_wrapper do
      unless File.exist?(META_DATA_FILE)
        raise StandardError,
              'meta data does not exist yet, please save some webpages first'
      end

      CSV.foreach(META_DATA_FILE, headers: true) do |row|
        data << row.to_hash if @urls.include?(row['url'])
      end
    end

    data
  end
end
