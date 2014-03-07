shared_context 'OAuth2 error' do
  before do
    stub_request(:get, 'auth.g5search.com/oauth/token/info').
      with(headers: {'Authorization'=>"Bearer #{token_value}"}).
      to_return(status: 401,
                headers: {'Content-Type' => 'application/json; charset=utf-8',
                          'Cache-Control' => 'no-cache'},
                body: parsed_error.to_json)
  end

  let(:parsed_error) { '' }
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
