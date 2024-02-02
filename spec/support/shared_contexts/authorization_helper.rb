shared_context 'with api authorization' do
  let(:user) { create(:user) }
  let(:headers) do
    {
      'X-User-Email' => user.email,
      'X-User-Token' => user.authentication_token
    }
  end
end
