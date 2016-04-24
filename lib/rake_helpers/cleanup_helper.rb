require 'rake_helpers/tar_helper'

# Methods to be used in the Rakefile related to cleanup the tmp folder.
module CleanupHelper
  # Remove the /tmp folder and all entries.
  def rm_tmp_folder
    CleanupHelper.rm_rf 'tmp'
  end

  # Remove the /tmp/data folder and all entries.
  def rm_tmp_data_folder
    CleanupHelper.rm_rf 'tmp/data'
  end

  # Remove the /tmp/data folder and all entries.
  def rm_archive
    CleanupHelper.rm_rf "tmp/#{TarHelper::ARCHIVE_NAME}"
  end

  # Remove recusive all files and folders under the specified path.
  #
  # @param [ String ] path
  def self.rm_rf(path)
    if File.exist? path
      FileUtils.rm_rf path
      puts "Removed #{path}"
    else
      $stderr.puts 'Nothing to cleanup'
    end
  end
end
