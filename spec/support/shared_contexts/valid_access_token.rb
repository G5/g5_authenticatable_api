shared_context 'valid access token' do
  let(:auth_client) { double(:g5_authentication_client) }
  before do
    allow(G5AuthenticationClient::Client).to receive(:new).and_return(auth_client)
  end

  let(:auth_user) { double(:auth_user, email: 'auth.user@test.host',
                                         id: 'user-uid-42') }
  before { allow(auth_client).to receive(:me).and_return(auth_user) }


  let(:token_info) { double(:token_info, resource_owner_id: 'user-uid-42',
                                         expires_in_seconds: 3600,
                                         application_uid: 'application-uid-42',
                                         scopes: []) }
  before { allow(auth_client).to receive(:token_info).and_return(token_info) }
end
