require "./config/assets-javascript.rb"

set :views, ["views","layouts","public"]
set :public_folder, "public"

# Use Rack::Deflater to gzip assets
use Rack::Deflater

# Loads up all models in path
Dir.glob("./models/*.rb").each {|r|
  require r
}

# Loads up all controllers in path
Dir.glob("./controllers/*.rb").each {|r|
  require r
}

configure do

  set :partial_template_engine, :erb

  Compass.add_project_configuration(File.join(Sinatra::Application.root, "config", "compass.config"))

  set(:public_stylesheets_path) { "/stylesheets/" }
  set(:public_javascripts_path) { "/javascripts/" }
  set(:public_images_path) { "/images/" }

  set(:show_debuginfo) { false }

  cacehbuster_string = rand(9999999999).to_s.center(10, rand(9).to_s).to_s
  set(:cachebuster_string) { cacehbuster_string }

  set(:bundle_cache_time, 60 * 60 * 24)
  disable(:stamp_bundles)
  enable(:cache_bundles)

end

configure :development do
  disable(:compress_bundles)
end

configure :production do
  enable(:compress_bundles)
end
