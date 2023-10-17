# typed: false
# frozen_string_literal: true

RSpec.shared_examples_for 'failed pricing response' do
  it 'returns a failed response' do
    expect(pricing.success?).to be(false)
  end

  it 'returns errors' do
    expect(pricing.errors).not_to be_empty
  end
end
