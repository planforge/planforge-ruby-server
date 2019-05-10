require "concurrent/atomics"

module PlanForge
  class MemoryStore
    def initialize()
      @store = {}
      @lock = Concurrent::ReadWriteLock.new
    end

    def get(key)
      key = key.to_sym
      @lock.with_read_lock do
        @store[key]
      end
    end

    def put(key, value)
      key = key.to_sym
      @lock.with_write_lock do
        @store[key] = value
      end
      value
    end

    def delete(key)
      key = key.to_sym
      @lock.with_write_lock do
        @store.delete(key)
      end
      true
    end

    def clear
      @lock.with_write_lock do
        @store = {}
      end
      true
    end
  end
end
