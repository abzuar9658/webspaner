class FolderManager
  def initialize(folder_name)
    @folder_name = folder_name
  end

  def create_folder
    return if File.directory?(@folder_name)

    FileUtils.mkdir_p(@folder_name)
    @folder_name
  end
end
