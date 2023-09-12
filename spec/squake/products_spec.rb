# typed: false

require 'spec_helper'

RSpec.describe Squake::Products, :vcr do
  let(:product_id) { 'product_026c41' }

  describe '#get' do
    context 'when getting single product' do
      context 'when successful' do
        it 'returns an array with single product' do
          response = described_class.get(client: squake_client, product_id: product_id)

          expect(response.success?).to be(true)
          expect(response.result).to be_a(Array)
          expect(response.result.first).to be_a(Squake::Model::Product)
        end
      end

      context 'when unsuccessful' do
        it 'returns an error' do
          response = described_class.get(client: squake_client, product_id: 'invalid_id')

          expect(response.success?).to be(false)
          expect(response.errors.first).to be_a(Squake::Errors::APIErrorResult)
        end
      end
    end

    context 'when getting all products' do
      context 'when successful' do
        it 'returns a list of products' do
          response = described_class.get(client: squake_client, product_id: product_id)

          expect(response.success?).to be(true)
          expect(response.result).to be_a(Array)
          response.result.map { expect(_1).to be_a(Squake::Model::Product) }
        end
      end

      context 'when unsuccessful' do
        it 'returns an error' do
          response = described_class.get(client: squake_client, product_id: 'invalid_id')

          expect(response.success?).to be(false)
          expect(response.errors.first).to be_a(Squake::Errors::APIErrorResult)
        end
      end
    end
  end
end
