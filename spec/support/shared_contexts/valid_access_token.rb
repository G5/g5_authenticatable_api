shared_context 'valid access token' do
  before do
    stub_request(:get, 'auth.g5search.com/oauth/token/info').
      with(headers: {'Authorization'=>"Bearer #{token_value}"}).
      to_return(status: 200,
                body: raw_token_info,
                headers: {'Content-Type' => 'application/json'})
  end

  let(:raw_token_info) do
    {
      "resource_owner_id" => 42,
      "scopes" => [],
      "expires_in_seconds" => 120,
      "application" => {"uid" => "abcdefg112358"}
    }
  end
end
