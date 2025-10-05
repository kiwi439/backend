require 'rails_helper'

describe Utils::CallableObject, type: :module do
  describe '.call' do
    let(:test_class) do
      Class.new do
        extend Utils::CallableObject

        def initialize(name:, age:)
          @name = name
          @age = age
        end

        def call
          "#{@name} is #{@age} years old"
        end
      end
    end

    it 'creates new instance and calls call method' do
      result = test_class.call(name: 'John', age: 25)
      expect(result).to eq('John is 25 years old')
    end
  end
end
