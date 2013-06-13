require 'rest_client'
require 'json'

class CreativeWorkClient
  def self.latest
    JSON.parse(BBCRestClient.get "https://api.stage.bbc.co.uk/ldp-core/creative-works")['@list'].to_json
  end
end

class BBCRestClient
  def self.get url
    RestClient::Resource.new(
      url,
      :ssl_client_cert => OpenSSL::X509::Certificate.new(File.open(File.join(File.dirname(__FILE__), '..', 'certificate.pem'))),
      :ssl_client_key => OpenSSL::PKey::RSA.new(File.open(File.join(File.dirname(__FILE__), '..', 'certificate.pem'))),
    ).get(:accept => "application/json-ld")
  end
end