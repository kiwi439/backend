require 'rails_helper'

describe Utils::ParamsParser, type: :module do
  describe '#convert_string_to_hash' do
    subject { parser.convert_string_to_hash(string: string) }  
  
    let(:parser) { Class.new { include Utils::ParamsParser }.new }

    context 'with valid string format' do
      let(:string) { 'name:John age:25 city:Warsaw' }

      it 'converts string to symbolized hash' do
        expect(subject).to eq({ name: 'John', age: '25', city: 'Warsaw' })
      end
    end

    context 'with empty string' do
      let(:string) { '' }

      it 'returns empty hash' do
        expect(subject).to eq({})
      end
    end

    context 'with single key-value pair' do
      let(:string) { 'status:active' }

      it 'converts single pair to hash' do
        expect(subject).to eq({ status: 'active' })
      end
    end

    context 'with numeric values' do
      let(:string) { 'count:10 price:99.99' }

      it 'converts numeric strings to hash' do
        expect(subject).to eq({ count: '10', price: '99.99' })
      end
    end
  end
end
