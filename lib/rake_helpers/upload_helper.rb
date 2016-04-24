require 'rake_helpers/tar_helper'

# Methods to be used in the Rakefile related to upload the archive.
module UploadHelper
  # Upload the archive to Dropbox.
  def upload_archive
    require 'dropbox_sdk'

    file   = open("tmp/#{TarHelper::ARCHIVE_NAME}")
    client = DropboxClient.new ENV['ACCESS_TOKEN']

    res = client.put_file("consorsbank.#{TarHelper::ARCHIVE_NAME}", file, true)

    puts "Uploaded #{res['size']} as rev #{res['revision']}/#{res['rev']}"
  rescue StandardError => e
    $stderr.puts "#{e.class}: #{e.message}"
  end
end
