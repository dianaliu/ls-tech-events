require 'spec_helper'

describe 'Events Routing' do
  it 'routes /events/export with default json format' do
    expect(:get => '/events/export').to route_to({
      :controller => 'events',
      :action => 'export',
      :format => 'json'
      })
  end
end