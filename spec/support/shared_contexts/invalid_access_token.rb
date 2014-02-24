shared_context 'OAuth2 error' do
  let(:auth_client) { double(:g5_authentication_client) }
  before do
    allow(G5AuthenticationClient::Client).to receive(:new).and_return(auth_client)
  end

  let(:oauth_error) { OAuth2::Error.new(oauth_response) }
  let(:oauth_response) { double(:oauth_response, parsed: parsed_error).as_null_object }

  let(:parsed_error) { '' }

  before do
    allow(auth_client).to receive(:me).and_raise(oauth_error)
    allow(auth_client).to receive(:token_info).and_raise(oauth_error)
  end
end

shared_context 'invalid access token' do
  include_context 'OAuth2 error' do
    let(:parsed_error) do
      {'error' => error_code,
       'error_description' => error_description}
    end

    let(:error_code) { 'invalid_token' }
    let(:error_description) { 'The access token expired' }
  end
end
