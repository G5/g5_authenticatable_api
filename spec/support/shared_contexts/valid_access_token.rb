shared_context 'valid access token' do
  before do
    stub_request(:get, 'auth.g5search.com/oauth/token/info').
      with(headers: {'Authorization'=>"Bearer #{token_value}"}).
         to_return(status: 200, body: '', headers: {})
  end
end
