# require all services files
Dir["#{Rails.root}/lib/services/**/*.rb"].each{|f| require f}