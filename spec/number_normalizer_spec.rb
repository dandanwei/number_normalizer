require 'spec_helper'

describe NumberNormalizer do
  it 'has a version number' do
    expect(NumberNormalizer::VERSION).not_to be nil
  end

  describe "#new" do
    it 'returns a new number_normalizer object' do
      expect( NumberNormalizer.new("text to search") ).to be_an_instance_of NumberNormalizer
    end

    it 'throws an ArgumentError when given more than one parameters' do
      expect( lambda { NumberNormalizer.new("text to search", "another text") } ).to raise_exception ArgumentError
    end

    it 'throws an ArgumentError when given less than one parameters' do
      expect( lambda { NumberNormalizer.new } ).to raise_exception ArgumentError
    end
  end

  describe "#text" do
    it 'returns the original text' do
      t = "this is a orig text 1, 2 3 and one two three. I count to one hundred and 1 million."
      n = NumberNormalizer.new t
      expect( n.text ).to eql t
    end
  end

  describe '#digit_numbers' do
    it 'returns digit numbers in array when feeding digits number' do
      t = "I am counting 1, 2, 3, 4 and 100.494 until 10049938. " \
          "A float number is 1223.232. A float number .1923. 1.abc.\n" \
          " 123.1123.\n" \
          ".123313, jdfdjf 1,adf .2.abc"
      n = NumberNormalizer.new t
      expect( n.digit_numbers ).to eql [1, 2, 3, 4, 100.494, 10049938, 1223.232, 0.1923, 123.1123, 0.123313]
    end

    it 'returns digit numbers in array when feeding integer digits numbers like 1, 2, 3, 101, 12349097320232' do
      t = "I am counting 1, 2, 3 and 101 until 12349097320232. "
      n = NumberNormalizer.new t
      expect( n.digit_numbers ).to eql [1, 2, 3, 101, 12349097320232]
    end

    it 'returns digit numbers in array when feeding floating digits numbers like 1223.232, 100.494, .1923' do
      t = "A floating numbers is like 1223.232 and 100.494. .1923 is also a floating number."
      n = NumberNormalizer.new t
      expect( n.digit_numbers ).to eql [1223.232, 100.494, 0.1923]
    end

    it 'returns digit numbers in array when feeding space seperated integer number like 10 123 456' do
      t = "The area is 10 123 456 square meters. The population is 1 300 000 000."
      n = NumberNormalizer.new t
      expect( n.digit_numbers ).to eql [10123456, 1300000000]
    end

    it 'returns digit numbers in array when feeding space seperated float number like 10 123.123 32' do
      t = "The area is 1 120 123.12 square meters. The number is is 10 123.123 32."
      n = NumberNormalizer.new t
      expect( n.digit_numbers ).to eql [1120123.12, 10123.12332]
    end

    it 'returns digit numbers in array when feeding comma seperated integer number like 10,123,456' do
      t = "The area is 10,123,456 square meters. The population is 1,300,000,000."
      n = NumberNormalizer.new t
      expect( n.digit_numbers ).to eql [10123456, 1300000000]
    end

    it 'returns digit numbers in array when feeding comma seperated float number like 10,123.123,32' do
      t = "The area is 1,120,123.12 square meters. The number is is 10,123.123,32."
      n = NumberNormalizer.new t
      expect( n.digit_numbers ).to eql [1120123.12, 10123.12332]
    end

    it 'returns non-duplicated digit numbers in array when feeding with duplicated numbers' do
      t = "You have 100 dollar. I have 50. He has 100 too."
      n = NumberNormalizer.new t
      expect( n.digit_numbers ).to eql [100, 50]
    end

    # TODO should or should not ?? -- maybe configuration
    it 'returns digit numbers in strings like "number1", "#10", "$1 100.50"' do
      t = "He is number 1. His address is road #10. She has $1 100.50."
      n = NumberNormalizer.new t
      expect( n.digit_numbers ).to eql [1, 10, 1100.5]
    end

    it 'returns digit numbers in array when feeding with integer numbers from 0 to 10 in words' do
      t = "I am counting zero, one, two, three, four, five, six, seven, eight, nine, ten."
      n = NumberNormalizer.new t
      expect( n.digit_numbers ).to eql [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    end

    it 'returns digit numbers in array when feeding with integer numbers from 11 to 19 in words' do
      t = "I am counting eleven, twelve, thirteen, fourteen, fifteen, sixteen, seventeen, eighteen, nineteen."
      n = NumberNormalizer.new t
      expect( n.digit_numbers ).to eql [11, 12, 13, 14, 15, 16, 17, 18, 19]
    end

    it 'returns digit numbers in array when feeding with integer numbers between 20 to 99 in words' do
      t = "I am counting twenty, twenty-one, thirty, thirty-two, forty, forty-three, fifty, fifty-four, sixty, sixty-five, seventy, seventy-six, eighty, eighty-seven, ninety, ninety-eight, ninety-nine."
      n = NumberNormalizer.new t
      expect( n.digit_numbers ).to eql [20, 21, 30, 32, 40, 43, 50, 54, 60, 65, 70, 76, 80, 87, 90, 98, 99]
    end

    it 'returns digit numbers in array when feeding with integer numbers larger than 100 in words' do
      t = "I am counting one hundred, five hundred, twenty thousand, ninety-six million three thousand."
      n = NumberNormalizer.new t
      expect( n.digit_numbers ).to eql [100, 500, 20000, 96003000]
    end

    it 'returns digit numbers in array when feeding with words like a hundred, a thousand, a million' do
      t = "There are a hundred cars, a thousand bicycles and a million people."
      n = NumberNormalizer.new t
      expect( n.digit_numbers ).to eql [100, 1000, 1000000]
    end

  end

  # pure number 100.11, one hundred, 1 million, 10^3, 0x30,
  # telephone numbers eg. +46464602121, 008613907015555, 0748756924
  # currency eg. $1000, one hundred dollar

end
