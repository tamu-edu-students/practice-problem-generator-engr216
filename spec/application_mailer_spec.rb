require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  it 'has the default from address' do
    expect(described_class.default[:from]).to eq('from@example.com')
  end

  it 'uses the correct layout' do
    expect(described_class._layout).to eq('mailer')
  end
end
