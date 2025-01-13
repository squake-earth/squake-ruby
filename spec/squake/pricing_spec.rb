# typed: false

require 'spec_helper'

RSpec.describe Squake::Pricing, :vcr do
  let(:product_id) { 'product_026c41' }

  describe '#quote' do
    context 'when requesting with fixed carbon_quantity' do
      subject(:pricing) do
        described_class.quote(
          client: squake_client,
          carbon_quantity: 1000,
          carbon_unit: 'kilogram',
          product_id: product_id,
        )
      end

      context 'when valid request' do
        it_behaves_like 'successful pricing response'
      end

      context 'when invalid request' do
        let(:product_id) { 'invalid' }

        it_behaves_like 'failed pricing response'
      end
    end

    context 'when requesting with expand argument' do
      subject(:pricing) do
        described_class.quote(
          client: squake_client,
          fixed_total: 1000,
          product_id: product_id,
          expand: %w[product price],
        )
      end

      it_behaves_like 'successful pricing response'

      it 'returns expanded product' do
        pricing.result.product.tap do |product|
          expect(product).to be_a(Squake::Model::Product)
          expect(product.id).to eq(product_id)
        end
      end

      it 'returns expanded price' do
        pricing.result.price.tap do |price|
          expect(price).to be_a(Squake::Model::Price)
        end
      end
    end

    context 'when requesting with fixed total' do
      subject(:pricing) do
        described_class.quote(
          client: squake_client,
          fixed_total: 1000,
          product_id: product_id,
        )
      end

      context 'when valid request' do
        it_behaves_like 'successful pricing response'
      end

      context 'when invalid request' do
        let(:product_id) { 'invalid' }

        it_behaves_like 'failed pricing response'
      end
    end

    context 'when requesting with payment method' do
      let(:product_id) { 'product_N7TnHY' }

      subject(:pricing) do
        described_class.quote(
          client: squake_client,
          product_id: product_id,
          payment_method: Squake::Model::PaymentMethod::Stripe,
          fixed_total: 1000,
        )
      end

      it_behaves_like 'successful pricing response'

      it 'contains payment link' do
        expect(pricing.result.payment_link).to be_a(String)
        expect(pricing.result.payment_link).to include('checkout.sandbox.squake.earth')
      end
    end
  end
end

