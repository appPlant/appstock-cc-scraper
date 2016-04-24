
# Methods to be used in the Rakefile related to building the archive.
module TarHelper
  # Name of the tar file
  ARCHIVE_NAME = 'data.tar.gz'.freeze

  # Remove the /tmp/data folder and all entries.
  def create_archive
    succeeded = system [
      "cd tmp/data && find . -name '*.json'",
      'cut -c 3-',
      "tar cfvz ../#{TarHelper::ARCHIVE_NAME} --files-from -"
    ].join('|')

    if succeeded
      puts "#{TarHelper::ARCHIVE_NAME} placed under tmp"
    else
      $stderr.puts 'Could not create the archive'
    end
  end
end
