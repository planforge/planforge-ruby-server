require 'sinatra'
require 'planforge'

PlanForge.api_key = ENV['PLANFORGE_API_KEY']

get '/' do
  customer = PlanForge::Customer.get('cus_Epgd3XNJn0NU1P')
  erb :index, :locals => {:customer => customer}
end
