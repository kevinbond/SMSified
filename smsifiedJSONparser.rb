require 'sinatra'
require 'json'
require 'net/https'
require 'smsified'

post '/' do  

  response = request.env["rack.input"].read
  response = JSON.parse(response)
  
  myPhoneNumber = 1xxxxxxxxxx
  
  message =  response["inboundSMSMessageNotification"]["inboundSMSMessage"]["message"]
  callerID =  response["inboundSMSMessageNotification"]["inboundSMSMessage"]["senderAddress"]


  if callerID == "tel:+#{myPhoneNumber}"
    to = message[0..10]
    message.slice!(0..10)
  else
    to = myPhoneNumber
    message = callerID + " " + message

  end
  url = URI.parse('http://api.smsified.com/v1/smsmessaging/outbound/{SMSified_phone_number}/requests')
  req = Net::HTTP::Post.new(url.path)
  req.basic_auth 'username', 'password'
  req.set_form_data({'address' => "#{to}", 'message' => "#{message}"})
  res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }

end