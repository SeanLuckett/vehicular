RSpec.shared_examples 'missing resource' do |klass|
  it 'returns 404 status code' do
    expect(response).to have_http_status '404'
  end

  it 'returns an error message' do
    error_json = json(response.body)['errors']
    expect(error_json.first['detail'])
      .to eq "Could not find #{klass.name.downcase} with that id"
  end
end