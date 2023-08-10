require 'httparty'
require 'nokogiri'
require 'fileutils'
require_relative './metadata'
require_relative './folder_manager'
require_relative './page_archiver'

class Fetcher
  attr_accessor :metadata, :errors

  def initialize(base_url, root_data_path)
    @base_url = base_url
    @folder_name = File.join(root_data_path, base_url.gsub(%r{https?://}, ''))
    @errors = []
  end

  def perform
    folder_name = folder(@folder_name)

    return unless folder_name

    archive_page(folder_name)
    fetch_metadata(html_document)

    errors.empty?
  end

  private

  def archive_page(folder_name)
    PageArchiver.new(@base_url).archive_page(folder_name)
  end

  def fetch_metadata(html_document)
    @metadata = MetaData.new(@base_url, html_document).collect_metadata
  end

  def folder(folder_name)
    FolderManager.new(folder_name).create_folder
  end

  def html_document
    @html_document ||= begin
      response = HTTParty.get(@base_url)
      response.success? ? Nokogiri::HTML(response.body) : nil
    end
  end
end
