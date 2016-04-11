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
    @matches = {}

    find_all_digits
  end

  def text
    @text
  end


  def getNumbersInDigits

    digits = Set.new

    @matches.each_key do |key|
      s = key.gsub(/[\s,]/, '')
      if s =~ /\./
        digits.add(s.to_f)
      else
        digits.add(s.to_i)
      end
    end
    return digits.to_a
  end

protected

  def tokenlize
    @text_array = @text.split(@token)
  end

  def find_all_digits
    digits_pattern_str = '(' + @p_space_sperated_digits + '|' \
                         + @p_comma_sperated_digits + '|' \
                         + @p_floating_digits + '|' \
                         + @p_floating_digits_2 + '|' \
                         + @p_digits_only + ')' \
                         + @p_end

    digits_pattern = Regexp.new(digits_pattern_str)

    @text.enum_for(:scan, digits_pattern).each do |m|
      mstr = m[0]
      position = Regexp.last_match.begin(0)
      if @matches.has_key?mstr
        @matches[mstr][:pos].push(position)
      else
        @matches[mstr] = {:pos => [position],
                          :type => :digits }
      end
    end
  end

end
