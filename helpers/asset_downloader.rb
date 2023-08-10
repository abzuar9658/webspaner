class AssetDownloader
  def initialize(asset_url)
    @asset_url = asset_url
  end

  def download_asset(local_url, output_folder)
    uri = URI(@asset_url)
    asset_path = uri.path
    asset_filename = File.basename(asset_path)
    asset_local_path = File.join(output_folder, asset_filename)

    response = HTTParty.get(uri)

    return if response.success? && !save_content(asset_local_path, response.body)

    relative_url = asset_local_path.sub(output_folder, '').gsub(%r{^/}, '')
    local_url.gsub(%r{/$}, '') + relative_url
  end

  private

  def save_content(file_path, content)
    return if file_path.end_with?('/')

    File.binwrite(file_path, content)
  end
end
