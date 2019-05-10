module PlanForge
  class Customer
    attr_accessor :data

    def self.all
      requestor = APIRequestor.new
      data = requestor.get('/state')
      all = []

      data.each do |key, value|
        PlanForge.store.put(key, value)
        all << Customer.new(value)
      end

      all
    end

    def self.get(id)
      id = id.to_sym
      requestor = APIRequestor.new
      begin
        data = requestor.get('/state', {'customer': id})
        customer_data = data[id]
        PlanForge.store.put(id, customer_data)
      rescue Faraday::Error
        customer_data = PlanForge.store.get(id)
      end
      customer = Customer.new(customer_data)
    end

    def initialize(data)
      @data = data
    end

    def feature_enabled(key)
      key = key.to_sym
      if @data[:features] and @data[:features][key] and @data[:features][key][:enabled]
        true
      else
        false
      end
    end
  end
end
