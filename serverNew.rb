require 'socket'
require 'json'

server = TCPServer.open(2000)  # Socket to listen on port 2000
loop {                         # Servers run forever
	
  client = server.accept       # Wait for a client to connect
  #request = client.gets
  #puts "REQUEST: #{request}"
  request = client.read_nonblock(256)
  request_header, request_body = request.split("\r\n\r\n", 2) # splits request into header and body
  filename = request_header.split[1][1..-1] # gets path from request header
  method = request_header.split[0] # gets method: GET or POST

  if File.exist?(filename) 
  	response_body = File.read(filename)
	client.puts "HTTP/1.1 200 OK\r\nContent-type:text/html\r\n\r\n"
	if method == "GET"
		client.puts response_body
	elsif method == "POST"
		params = JSON.parse(request_body)
		user_data = "<li>name: #{params['viking']['name']}</li><li>e-mail: #{params['viking']['email']}</li>"
		client.puts response_body.gsub('<%= yield %>', user_data)
	end
else
	client.puts "HTTP/1.1 404/Object Not Found\r\nServer: Dayn\r\n\r\n"
end

  client.puts(Time.now.ctime)  # Send the time to the client
  client.puts "Closing the connection. Bye!"
  client.close                 # Disconnect from the client
}