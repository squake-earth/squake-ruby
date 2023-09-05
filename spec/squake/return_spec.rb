# typed: false

require 'spec_helper'

RSpec.describe Squake::Return do
  subject(:return_object) { described_class.new(result: result, errors: errors) }

  let(:result) { nil }
  let(:errors) { nil }
  let(:error) { Squake::Errors::APIErrorResult.new(code: :some_code, detail: 'some_detail') }

  describe '#success?' do
    [
      { result: [], errors: nil },
      { result: {}, errors: nil },
      { result: nil, errors: [] },
    ].each do |args|
      context "when initialized with #{args}" do
        let(:result) { args.fetch(:result) }
        let(:errors) { args.fetch(:errors) }

        it 'returns true' do
          expect(return_object.success?).to be(true)
        end
      end
    end
  end

  describe '#failed?' do
    [
      { result: [], errors: nil },
      { result: {}, errors: nil },
      { result: nil, errors: [] },
    ].each do |args|
      context "when initialized with #{args}" do
        let(:result) { args.fetch(:result) }
        let(:errors) { args.fetch(:errors) }

        it 'returns false' do
          expect(return_object.failed?).to be(false)
        end
      end
    end

    context 'when initialized with errors' do
      let(:errors) { [error] }

      it 'returns true' do
        expect(return_object.failed?).to be(true)
      end
    end
  end
end
