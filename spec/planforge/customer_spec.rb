CUSTOMER_DATA = {
    'features': {
        'test_feature': {
            'slug': 'test_feature',
            'enabled': true,
            'name': 'Test Feature'
        }
    }
}


PlanForge.api_key = 'apikey'

RSpec.describe PlanForge::Customer do
  before(:context) do
    PlanForge.store.clear
  end

  it "request all stores data and returns array of customers" do
    data = {
      'cus_0000000': CUSTOMER_DATA,
      'cus_0000001': CUSTOMER_DATA
    }
    stub_request(:get, 'http://localhost:8000/api/state').
      to_return(body: JSON.generate(data))

    response = PlanForge::Customer.all

    assert_requested :get, 'http://localhost:8000/api/state',
      headers: {'Authorization': 'Bearer apikey'},
      query: {}

    expect(response[0].data).to eq(CUSTOMER_DATA)
    expect(response[1].data).to eq(CUSTOMER_DATA)
    expect(PlanForge.store.get('cus_0000000')).to eq(CUSTOMER_DATA)
    expect(PlanForge.store.get('cus_0000001')).to eq(CUSTOMER_DATA)
  end

  it "get stores data and returns" do
    data = {
      'cus_0000000': CUSTOMER_DATA,
    }
    stub_request(:get, 'http://localhost:8000/api/state').
      with(query: {'customer' => 'cus_0000000'}).
      to_return(body: JSON.generate(data))

    response = PlanForge::Customer.get('cus_0000000')

    assert_requested :get, 'http://localhost:8000/api/state',
      headers: {'Authorization': 'Bearer apikey'},
      query: {'customer': 'cus_0000000'}

    expect(response.data).to eq(CUSTOMER_DATA)
    expect(PlanForge.store.get('cus_0000000')).to eq(CUSTOMER_DATA)
  end

  it "get returns stored data if api is unavailable" do
    PlanForge.store.put('cus_0000000', CUSTOMER_DATA)
    stub_request(:get, 'http://localhost:8000/api/state').
      with(query: {'customer' => 'cus_0000000'}).
      to_timeout
    response = PlanForge::Customer.get('cus_0000000')
    expect(response.data).to eq(CUSTOMER_DATA)
  end

  it "feature_enabled returns true" do
    customer = PlanForge::Customer.new(CUSTOMER_DATA)
    enabled = customer.feature_enabled('test_feature')
    expect(enabled).to eq(true)
  end

  it "feature_enabled returns false" do
    data = CUSTOMER_DATA.clone
    data[:features][:test_feature][:enabled] = false
    customer = PlanForge::Customer.new(data)
    enabled = customer.feature_enabled('test_feature')
    expect(enabled).to eq(false)
  end

  it "feature_enabled returns false if features unset" do
    customer = PlanForge::Customer.new({})
    enabled = customer.feature_enabled('test_feature')
    expect(enabled).to eq(false)
  end

  it "feature_enabled returns false if key unset" do
    customer = PlanForge::Customer.new(CUSTOMER_DATA)
    enabled = customer.feature_enabled('other_feature')
    expect(enabled).to eq(false)
  end
end
