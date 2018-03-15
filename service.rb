require 'sinatra'
require 'pry'

configure do
  enable :logging, :dump_errors, :raise_errors
end

get '/' do
  'Hello World! This project takes notifications from Chef Automate about failed
  Chef Client and Inspec runs, formats them, and sends the result to a HipChat
  room. See <a href="https://github.com/kevinreedy/automate-hipchat-notifier">
  https://github.com/kevinreedy/automate-hipchat-notifier</a> for more details.'
end

post '/' do
  message = JSON.parse(request.body.read)

  # Write message to file for now for troubleshooting
  File.write('./data/output.txt', JSON.pretty_generate(message))

  # A1 webhook test
  if message['username'] == 'Chef_Automate' && message['attachments']
    puts 'Received webhook test from Chef Automate 1.x:'
    puts JSON.pretty_generate(message)
    halt 200
  end

  # A2 webhook test
  if message['text'] == 'TEST: Successful validation completed by Automate'
    puts 'Received webhook test from Chef Automate 2.x:'
    puts JSON.pretty_generate(message)
    halt 200
  end

  if message['type'] == 'node_failure'
    puts 'Received node failure:'
    puts JSON.pretty_generate(message)
    halt 200
  end

  if message['type'] == 'compliance_failure'
    puts 'Received compliance failure:'
    puts JSON.pretty_generate(message)
    halt 200
  end

  # Didn't find a message we care about, so 404
  halt 404
end
