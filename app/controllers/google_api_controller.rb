require 'httpclient'
require 'base64'
require 'json'

class GoogleCloudVisionController < ApplicationController
  def initialize(file_path)
    @endpoint_uri = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV['GOOGLE_VISION_API_KEY']}"
    @file_path = file_path
  end


  def request
    http_client = HTTPClient.new
    content = Base64.strict_encode64(File.new(@file_path, 'rb').read)
    response = http_client.post_content(@endpoint_uri, request_json(content), 'Content-Type' => 'application/json')
    result_parse(response)
  end

  def request_json(content)
    {
      requests: [{
        image: {
          content: content
        },
        features: [{
          type: "LABEL_DETECTION",
          maxResults: 10
        }]
      }]
    }.to_json
  end

  def result_parse(response)
    result = JSON.parse(response)['responses'].first
    label = result['labelAnnotations'].first
    puts "これは、#{label['description']}です。"
  end

end

fox = GoogleCloudVision.new("/Users/usudashin/Projects/fox.jpg")
fox.request