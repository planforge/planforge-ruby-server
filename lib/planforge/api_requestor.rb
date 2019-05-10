require 'faraday'

module PlanForge
  class APIRequestor
    def initialize()
      @api_key = PlanForge.api_key
      @api_base = PlanForge.api_base
    end

    def get(url, params = {})
      conn = Faraday.new(:url => "#{@api_base}#{url}")
      response = conn.get do |req|
        req.params = params
        req.headers['Authorization'] = "Bearer #{@api_key}"
      end

      if response.status > 299
        raise APIError, 'Server Error'
      end

      JSON.parse(response.body, {symbolize_names: true})
    end
  end
end
