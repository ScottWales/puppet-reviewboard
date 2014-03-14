require 'spec_helper'
require 'net/http'

describe 'access reviewboard' do
    it 'returns a web page' do
        response = Net::HTTP.get_response(URI('http://localhost:8090/reviewboard/r/'))
        expect(response.message).to eq('OK')
    end
end

describe 'create review request' do
    it 'POSTs successfully' do
        uri = URI('http://localhost:8090/reviewboard/api/review-requests/')
        request = Net::HTTP::Post.new(uri.path)
        request.basic_auth('admin','testing')
        response = Net::HTTP.new(uri.host,uri.port).start {|http| http.request(request)}
        expect(response.message).to eq('CREATED')
    end
end
