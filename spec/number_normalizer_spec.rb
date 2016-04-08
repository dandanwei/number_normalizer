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
      t = "I am counting 1, 2, 3, 4 and 100.494 until 10049938. A float number is 1223.232."
      n = NumberNormalizer.new t
      n.getNumbersInDigits.should eql [1, 2, 3, 4, 100.494, 10049938, 1223.232]
    end

    it 'returns digit numbers in array when feeding with integer numbers within 100 in words' do
      t = "I am counting five, ten, twenty-five, eighteen, one"
      n = NumberNormalizer.new t
      n.getNumbersInDigits.should eql [5, 10, 25, 18, 1]
    end
  end

  # 100.11, one hundred, 1 million, 10^3, 0x30,


end
