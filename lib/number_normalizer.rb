require "number_normalizer/version"

class NumberNormalizer

  def initialize text
    @text =  text
    # parse all numbers and store it in an array
    # [ {original_format => "1 thousand",
    #    digit_format => "1000",
    #    word_format => "one thousand",
    #    occurance => 1}, ... ]
  end

  def text
    @text
  end

  def getNumbersInDigits

  end

end
