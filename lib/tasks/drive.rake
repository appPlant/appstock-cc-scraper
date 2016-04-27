require 'dropbox_sdk'

namespace :drive do
  desc 'Download list from external drive'
  task(:download) { download_list }

  desc 'Upload archive to external drive'
  task(upload: [:tar]) { upload_archive }

  desc 'Check accessibility of external drive'
  task(:check) { drive && puts('OK') }

  task(:tar) { create_archive }
end

private

# Dowload the list from external drive and plance under the tmp/ folder.
def download_list
  content, meta = drive.get_file_and_metadata('consorsbank.stocks.txt')

  mkdir_p('tmp') && IO.write('tmp/stocks.txt', content)

  puts "Downloaded #{content.split.size} stocks from rev #{meta['rev']}"
rescue StandardError => e
  $stderr.puts "#{e.class}: #{e.message}"
end

# Upload the archive to external drive.
def upload_archive
  file = open('tmp/stocks.tar.gz')
  meta = drive.put_file('consorsbank.stocks.tar.gz', file, true)

  puts "Uploaded #{meta['size']} with rev #{meta['rev']}"
rescue StandardError => e
  $stderr.puts "#{e.class}: #{e.message}"
end

# Create a tar of all scraped stock data.
def create_archive
  successful = system [
    "cd tmp && find . -name '*.json'",
    'cut -c 3-',
    'tar cfvz consorsbank.stocks.tar.gz --files-from -'
  ].join('|')

  $stderr.puts 'Could not create the archive' unless successful
end

# Dropbox client instance.
# Throws an error if authentification fails.
#
# @return [ DropboxClient ]
def drive
  @client ||= DropboxClient.new ENV['ACCESS_TOKEN']
end
