require 'socket'
require 'json'
host = 'localhost'     # The web server
port = 2000            # Default HTTP port
params = Hash.new { |hash, key| hash[key] = Hash.new }

input = ''
until input == 'g' || input == 'p'
	print 'What type of request do you want to submit [GET, POST], g/p? '
	input = gets.chomp
end

if input == 'p'
	print 'name: '
	name = gets.chomp
	print 'e-mail: '
	email = gets.chomp
	params[:viking][:name] = name
	params[:viking][:email] = email
	body = params.to_json
	# create request line to send to server
	request = "POST /thanks.html HTTP/1.0\r\nContent-Length: #{params.to_json.length}\r\n\r\n#{body}"
else
	request = "GET /index.html HTTP/1.0\r\n\r\n"
end

socket = TCPSocket.open(host,port)  # Connect to server
socket.print(request)               # Send request
response = socket.read              # Read complete response
headers,body = response.split("\r\n\r\n", 2) 
puts ''
print body	# And display it

socket.close

# This is the HTTP request we send to fetch a file
#request = "GET #{path} HTTP/1.0\r\n\r\n"


