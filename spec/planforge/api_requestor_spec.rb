PlanForge.api_key = 'apikey'

RSpec.describe PlanForge::APIRequestor do
  it "sets proper params on request" do
    stub_request(:get, "http://localhost:8000/api/state").
      to_return(body: '{}')
    requestor = PlanForge::APIRequestor.new
    requestor.get('/state')
    assert_requested :get, 'http://localhost:8000/api/state',
      headers: {'Authorization': 'Bearer apikey'}
  end

  it "throws exception for non-200 response" do
    stub_get = stub_request(:get, "http://localhost:8000/api/state").
      to_return(status: 403, body: '{"error": "Server Error"}')
    requestor = PlanForge::APIRequestor.new
    expect{ requestor.get('/state') }.to raise_error(PlanForge::APIError)
  end

  it "get returns a response" do
    stub_request(:get, "http://localhost:8000/api/state").
      to_return(body: '{"hello": "world"}')
    requestor = PlanForge::APIRequestor.new
    response = requestor.get('/state')
    expect(response[:hello]).to eq('world')
  end
end
