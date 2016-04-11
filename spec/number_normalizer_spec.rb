require 'spec_helper'

describe NumberNormalizer do
  it 'has a version number' do
    expect(NumberNormalizer::VERSION).not_to be nil
  end

  describe "#new" do
    it 'returns a new number_normalizer object' do
      NumberNormalizer.new("text to search").should be_an_instance_of NumberNormalizer
    end

    it 'throws an ArgumentError when given more than one parameters' do
      lambda { NumberNormalizer.new("text to search", "another text") }.should raise_exception ArgumentError
    end

    it 'throws an ArgumentError when given less than one parameters' do
      lambda { NumberNormalizer.new }.should raise_exception ArgumentError
    end
  end

  describe "#text" do
    it 'returns the original text' do
      t = "this is a orig text 1, 2 3 and one two three. I count to one hundred and 1 million."
      n = NumberNormalizer.new t
      n.text.should eql t
    end
  end

  describe '#getNumbersInDigits' do
    it 'returns digit numbers in array when feeding digits number' do
      t = "I am counting 1, 2, 3, 4 and 100.494 until 10049938. " \
          "A float number is 1223.232. A float number .1923. 1.abc.\n" \
          " 123.1123.\n" \
          ".123313, jdfdjf 1,adf .2.abc"
      n = NumberNormalizer.new t
      n.getNumbersInDigits.should eql [1, 2, 3, 4, 100.494, 10049938, 1223.232, 0.1923, 123.1123, 0.123313]
    end

    it 'returns digit numbers in array when feeding space seperated integer number like 10 123 456' do
      t = "The area is 10 123 456 square meters. The population is 1 300 000 000."
      n = NumberNormalizer.new t
      n.getNumbersInDigits.should eql [10123456, 1300000000]
    end

    it 'returns digit numbers in array when feeding space seperated float number like 10 123.123 32' do
      t = "The area is 1 120 123.12 square meters. The number is is 10 123.123 32."
      n = NumberNormalizer.new t
      n.getNumbersInDigits.should eql [1120123.12, 10123.12332]
    end

    it 'returns digit numbers in array when feeding comma seperated integer number like 10,123,456' do
      t = "The area is 10,123,456 square meters. The population is 1,300,000,000."
      n = NumberNormalizer.new t
      n.getNumbersInDigits.should eql [10123456, 1300000000]
    end

    it 'returns digit numbers in array when feeding comma seperated float number like 10,123.123,32' do
      t = "The area is 1,120,123.12 square meters. The number is is 10,123.123,32."
      n = NumberNormalizer.new t
      n.getNumbersInDigits.should eql [1120123.12, 10123.12332]
    end

    it 'returns non-duplicated digit numbers in array when feeding with duplicated numbers' do
      t = "You have 100 dollar. I have 50. He has 100 too."
      n = NumberNormalizer.new t
      n.getNumbersInDigits.should eql [100, 50]
    end

    # TODO should or should not ?? -- maybe configuration
    it 'returns digit numbers in strings like "number1", "#10", "$1 100.50"' do
      t = "He is number 1. His address is road #10. She has $1 100.50."
      n = NumberNormalizer.new t
      n.getNumbersInDigits.should eql [1, 10, 1100.5]
    end

    it 'returns digit numbers in array when feeding with integer numbers within 100 in words' do
      t = "I am counting five, ten, twenty-five, eighteen, one"
      n = NumberNormalizer.new t
      n.getNumbersInDigits.should eql [5, 10, 25, 18, 1]
    end
  end

  # pure number 100.11, one hundred, 1 million, 10^3, 0x30,
  # telephone numbers eg. +46464602121, 008613907015555, 0748756924
  # currency eg. $1000, one hundred dollar

end
