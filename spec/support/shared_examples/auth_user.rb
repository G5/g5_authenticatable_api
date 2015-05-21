shared_examples_for 'an auth user' do
  it 'has the correct id' do
    expect(user.id).to eq(raw_user_info['id'])
  end

  it 'has the correct email' do
    expect(user.email).to eq(raw_user_info['email'])
  end

  it 'has the correct first_name' do
    expect(user.first_name).to eq(raw_user_info['first_name'])
  end

  it 'has the correct last_name' do
    expect(user.last_name).to eq(raw_user_info['last_name'])
  end

  it 'has the correct phone_number' do
    expect(user.phone_number).to eq(raw_user_info['phone_number'])
  end

  it 'has the correct title' do
    expect(user.title).to eq(raw_user_info['title'])
  end

  it 'has the correct organization_name' do
    expect(user.organization_name).to eq(raw_user_info['organization_name'])
  end

  it 'has the correct number of roles' do
    expect(user.roles.count).to eq(raw_user_info['roles'].count)
  end
end
