require "number_normalizer/version"

class NumberNormalizer

  def initialize text
    @text =  text
    @token = ' '
    @text_array = []
    # parse all numbers and store it in an array
    # [ {original_format => "1 thousand",
    #    digit_format => "1000",
    #    word_format => "one thousand",
    #    occurance => 1}, ... ]
    @p_digits_only = '\d+'
    @p_floating_digits = '\d+\.\d+'
    @p_floating_digits_2 = '\.\d+'
    @p_space_sperated_digits = '\d{,3}(\s\d{3}){1,}(\.\d{1,3}){,1}(\s\d{3})*(\s\d{,3})?'
    @p_comma_sperated_digits = '\d{,3}(,\d{3}){1,}(\.\d{1,3}){,1}(,\d{3})*(,\d{,3})?'
    @p_begin = ''
    @p_end = '\W?(\s|$)'
  end

  def text
    @text
  end

  # 0-9 . , \s
  def getNumbersInDigits
    # regex on whole string or each token
    # will miss #1, number1 --> need manual exclusion
    digits_pattern = '(' + @p_space_sperated_digits + '|' \
                         + @p_comma_sperated_digits + '|' \
                         + @p_floating_digits + '|' \
                         + @p_floating_digits_2 + '|' \
                         + @p_digits_only + ')' \
                         + @p_end

    digits = @text.scan(Regexp.new(digits_pattern)).map do |m|
        s = m[0].gsub(/[\s,]/, '')
        if s =~ /\./
          s.to_f
        else
          s.to_i
        end
      end
    return digits
  end

protected

  def tokenlize
    @text_array = @text.split(@token)
  end

  def remove_not_number_text
  end

end
