require 'http'

task ping: :environment do
  puts "Pinging..."
  HTTP.get('http://road-network-api.herokuapp.com/')
  puts 'done.'
end
