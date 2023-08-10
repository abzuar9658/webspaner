require 'httparty'
require 'nokogiri'
require 'fileutils'
require_relative './asset_downloader'

class PageArchiver
  def initialize(base_url)
    @base_url = base_url
  end

  def archive_page(output_folder)
    content = fetch_content

    return unless content

    uri = URI.parse(@base_url)
    local_url = "#{uri.scheme}://#{uri.host}"

    page_filename = "#{uri.host}#{uri.path}".gsub(%r{[/:?&=]}, '_')
    page_local_path = File.join(output_folder, "#{page_filename}.html")

    save_content(page_local_path, content)

    assets_to_download = collect_assets_to_download(content)
    download_assets(assets_to_download, local_url, output_folder)
  end

  private

  def fetch_content
    response = HTTParty.get(@base_url)
    response.success? ? response.body : nil
  end

  def save_content(file_path, content)
    File.write(file_path, content)
  end

  def collect_assets_to_download(content)
    html_document = Nokogiri::HTML(content)
    assets_to_download = []

    html_document.css('img, link, script').each do |element|
      asset_url = element['src'] || element['href']

      next unless asset_url

      assets_to_download << if asset_url.start_with?('http')
                              asset_url
                            else
                              File.join(@base_url, asset_url)
                            end
    end

    assets_to_download
  end

  def download_assets(assets_to_download, local_url, output_folder)
    assets_to_download.each do |asset_url|
      asset_downloader = AssetDownloader.new(asset_url)
      asset_downloader.download_asset(local_url, output_folder)
    end
  end
end
