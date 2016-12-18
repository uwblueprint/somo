require 'rails_helper'

describe SurveysController, :type => :routing do

  it 'get all surveys routes properly' do
    expect(get('/surveys')).to route_to(
      controller: 'surveys',
      action: 'index'
    )
  end

  it 'get surveys routes properly' do
    expect(get('/surveys/1')).to route_to(
      controller: 'surveys',
      action: 'show',
      id: '1'
    )
  end

  it 'post surveys routes properly' do
    expect(post('/surveys')).to route_to('surveys#create')
  end

  it 'put surveys routes properly' do
    expect(put('/surveys/1')).to route_to(
      controller: 'surveys',
      action: 'update',
      id: '1',
    )
  end

  it 'send surveys routes properly' do
    expect(post('/surveys/1/send')).to route_to(
      controller: 'surveys',
      action: 'send_survey',
      id: '1'
    )
  end
end
