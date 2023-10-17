# typed: false
# frozen_string_literal: true

RSpec.shared_examples_for 'successful pricing response' do
  it 'returns a success response' do
    expect(pricing.success?).to be(true)
  end

  it 'returns a pricing object' do
    expect(pricing.result).to be_a(Squake::Model::Pricing)
  end
end
