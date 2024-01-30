shared_examples 'responds with correct status' do |status|
  it "responds with #{status} status" do
    expect(response).to have_http_status(status)
  end
end
