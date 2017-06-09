# frozen_string_literal: true

RSpec.shared_context 'current auth user' do
  before do
    stub_request(:get, 'auth.g5search.com/v1/me')
      .with(headers: { 'Authorization' => "Bearer #{token_value}" })
      .to_return(status: 200,
                 body: raw_user_info.to_json,
                 headers: { 'Content-Type' => 'application/json' })
  end

  let(:raw_user_info) do
    {
      'id' => 42,
      'email' => 'fred.rogers@thehood.net',
      'first_name' => 'Fred',
      'last_name' => 'Rogers',
      'phone_number' => '(555) 555-1212',
      'organization_name' => 'The Neighborhood',
      'title' => 'Head Cardigan Wearer',
      'roles' => [
        {
          'name' => 'viewer',
          'type' => 'GLOBAL',
          'urn' => nil
        },
        {
          'name' => 'admin',
          'type' => 'G5Updatable::Client',
          'urn' => 'g5-c-some-randomly-generated-string'
        }
      ]
    }
  end
end
