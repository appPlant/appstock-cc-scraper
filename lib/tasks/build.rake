
namespace :build do
  desc 'Remove dangling images and exited containers'
  task :clean do
    system 'docker rm $(docker ps -a -q -f status=exited)'
    system 'docker rmi $(docker images -q -f dangling=true)'
  end

  desc 'Build image for stocks tag'
  task(:stocks) { task('build:tag').invoke(:stocks) }

  desc 'Build image for intra tag'
  task(:intra) { task('build:tag').invoke(:intra) }

  desc 'Build image for test tag'
  task(:test) { task('build:tag').invoke(:test) }

  task(:tag, [:tag]) do |_, args|
    tag   = args[:tag] || 'edge'
    image = "appdax/cc-scraper:#{tag}"

    FileUtils.ln_s "build/#{tag}/.dockerignore", '.dockerignore'
    system "docker build -t #{image} -f build/#{tag}/Dockerfile ."
    FileUtils.rm '.dockerignore'
  end
end
