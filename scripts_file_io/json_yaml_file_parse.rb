require 'json'
require 'yaml'

airports = JSON.parse(File.read('airports.json'))

# we can also we like
# airports = JSON.load_file('airports.json')

airports['airports'].each do |airport|
  # puts airport['code']
  # puts airport['name']
end

config = YAML.load_file('sample1.yaml')
puts config['application']['name']
