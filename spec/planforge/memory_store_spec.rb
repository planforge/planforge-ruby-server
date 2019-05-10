RSpec.describe PlanForge::MemoryStore do
  it "put inserts object into store and returns value" do
    value = PlanForge.store.put("hello", "world")
    expect(value).to eq("world")
    expect(PlanForge.store.get("hello")).to eq("world")
  end

  it "delete removes value from store" do
    PlanForge.store.put("hello", "world")
    value = PlanForge.store.delete("hello")
    expect(value).to eq(true)
    expect(PlanForge.store.get("hello")).to eq(nil)
  end

  it "clear removes all values from store" do
    PlanForge.store.put("hello", "world")
    value = PlanForge.store.clear()
    expect(value).to eq(true)
    expect(PlanForge.store.get("hello")).to eq(nil)
  end
end
