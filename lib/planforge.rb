require 'planforge'
require 'planforge/api_requestor'
require 'planforge/customer'
require 'planforge/errors'
require 'planforge/memory_store'
require 'planforge/version'

module PlanForge
  @api_base = 'http://localhost:8000/api'
  @store = MemoryStore.new

  class << self
    attr_accessor :api_key, :api_base, :store
  end
end
