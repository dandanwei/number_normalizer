require "number_normalizer/version"
require "set"

class NumberNormalizer

  attr_reader :text
  attr_reader :matches

  NUM_WORD = {
    'zero'       =>  0 ,
    'one'        =>  1 ,
    'two'        =>  2 ,
    'three'      =>  3 ,
    'four'       =>  4 ,
    'five'       =>  5 ,
    'six'        =>  6 ,
    'seven'      =>  7 ,
    'eight'      =>  8 ,
    'nine'       =>  9 ,
    'ten'        =>  10,
    'eleven'     =>  11,
    'twelve'     =>  12,
    'thirteen'   =>  13,
    'fourteen'   =>  14,
    'fifteen'    =>  15,
    'sixteen'    =>  16,
    'seventeen'  =>  17,
    'eighteen'   =>  18,
    'nineteen'   =>  19,
    'twenty'     =>  20,
    'thirty'     =>  30,
    'forty'      =>  40,
    'fifty'      =>  50,
    'sixty'      =>  60,
    'seventy'    =>  70,
    'eighty'     =>  80,
    'ninety'     =>  90,
    'a'          =>  1,
    'an'         =>  1,
  }

  MULT_WORD = {
    'half'       => 0.5,
    'dozen'      => 12,
    'hundred'    => 100,
    'thousand'   => 1000,
    'million'    => 1000000,
    'billion'    => 1000000000,
    'trillion'   => 1000000000000,
  }

  ADJ_WORD = {
    '-'          => 0,
    'and'        => 0,
  }

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

    find_all_words
  end

  def digit_numbers

    convert_digit_string_to_numbers
    digits = Set.new

    #puts @matches

    @matches.each_value do |v|
      if v.has_key?:digit_form
        digits.add(v[:digit_form])
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
                          :type => :digits}
      end
    end
  end

  def find_all_words
    text_arr = preprocess(@text)

    num_words = ''
    temp_words = ''
    temp_num = 0
    temp_mode = 0
    hundred_num = 0
    final_num = 0
    flag = false
    is_prev_mult = false
    is_prev_num = false

    text_arr.each do |str|
      num = NUM_WORD[str]
      mult = MULT_WORD[str]
      adj = ADJ_WORD[str]
      #puts "#{str}==#{num}==#{mult}==#{adj}=="

      if num != nil
        if temp_mode > 100
          temp_num += num
          temp_words = temp_words + ' ' + str
        else
          hundred_num += num
          num_words = num_words + ' ' + str
          temp_mode = 0
        end
        flag = true
        is_prev_mult = false
        is_prev_num = true
      elsif flag  && adj != nil && ((str == '-') || (is_prev_mult && (str == 'and')))
        if temp_mode >= 100 && temp_mode % 10 == 0 && str == 'and'
          temp_mode += 1
        end
        num_words = num_words + ' ' + str if str == 'and'
        num_words += str if str == '-'
        is_prev_mult = false
        is_prev_num = false
      elsif flag && mult != nil
        if (temp_mode > 1000 && temp_mode % 10 == 1) || (temp_mode > 100 && temp_mode < 1000 && mult < 1000)
          # 2 numbers
          # -- save previous number first
          final_num += hundred_num
          save_num_words(num_words.strip, final_num)
          # -- start counting current number
          num_words = temp_words
          hundred_num = temp_num
          temp_words = ''
          temp_num = 0
          final_num = 0
        else
          # 1 number
          hundred_num += temp_num
          temp_num = 0
        end
        hundred_num *= mult
        if hundred_num >= 1000
          final_num += hundred_num
          hundred_num = 0
        end
        num_words = num_words + ' ' + str
        is_prev_mult = true
        is_prev_num = false
        temp_mode = mult
      elsif flag
        final_num += hundred_num + temp_num
        save_num_words(num_words.strip, final_num)
        num_words = ''
        final_num = 0
        hundred_num = 0
        temp_num = 0
        temp_words = ''
        temp_mode = 0
        flag = false
        is_prev_mult = false
        is_prev_num = false
      end
    end

    save_num_words(num_words.strip, final_num + hundred_num) if flag
  end

  def save_num_words(num_words, number)
    @matches[num_words] = {:pos => [1],
                          :type => :words,
                          :digit_form => number}
  end

  def convert_digit_string_to_numbers
    @matches.each_pair do |key, value|
      if value[:type] == :digits
        s = key.gsub(/[\s,]/, '')
        value[:digit_form] = if s =~ /\./ then s.to_f else s.to_i end
      end
    end
  end

  def preprocess(str)
    str.downcase.gsub(/([^a-zA-Z0-9\s])/, ' \1 ').split()
  end

end
