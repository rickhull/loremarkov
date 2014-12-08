class Loremarkov
  TOKENS = ["\n", "\t", ' ', "'", '"']

  # Decompose text into an array of tokens, including and delimited by TOKENS
  # e.g. "Hello", he said.
  # # => ['"', 'Hello', '"', ',', ' ', 'he', ' ', 'said.',]
  # This operation can be losslessly reversed by calling #join on the resulting
  # array.
  # i.e. lex(str).join == str
  #
  def self.lex(str, tokens = TOKENS)
    final_ary = []
    word = ''
    str.each_byte { |b|   # yes I am terrible with encodings
      # either a token (thereby ending the current word)
      # or part of the current word
      #
      if tokens.include?(b.chr)
        final_ary << word if !word.empty?
        final_ary << b.chr
        word = ''
      else
        word << b.chr
      end
    }
    final_ary << word if !word.empty?
    final_ary
  end


  # Generate a markov data structure
  # Arrays of string for keys and values
  # Keys are prefixes -- ordered word sequence of constant length
  # Values are an accumulation of the next word after the prefix, however many
  # times it may occur.
  # e.g. If a prefix occurs twice, then the value will be
  # an array of two words -- possibly the same word twice.
  #
  def self.analyze(text, num_prefix_words)
    markov = {}
    words = lex(text)

    # Go through the possible valid prefixes.
    # Adding 1 gives you the final key:
    # *num_prefix_words* words with a nil value  -- signifying EOF
    #
    (words.length - num_prefix_words + 1).times { |i|
      prefix_words = []
      num_prefix_words.times { |j| prefix_words << words[i + j] }

      # set to empty array on a new prefix
      #
      markov[prefix_words] ||= []
      # add the target word, which will be nil on the last iteration
      markov[prefix_words] << words[i + num_prefix_words]
    }
    markov
  end

  # given the entire text, use an extremely conservative heuristic
  # to grab only the first chunk to pass to lex
  #
  def self.start_prefix(text, num_prefix_words)
    char_per_word = 20
    token_frequency = 0.5
    min_length = 60
    length = [char_per_word * (num_prefix_words * (1 - token_frequency)).ceil, min_length].max
    lex(text[0, length])[0, num_prefix_words]
  end

  attr_reader :markov

  def initialize(num_prefix_words)
    @num_prefix_words = num_prefix_words
    @markov = {}
  end

  # text should have a definite end, not just a convenient buffer split
  #
  def analyze(text)
    @markov.merge!(self.class.analyze(text, @num_prefix_words))
  end

  # given a prefix, give me the next word
  #
  def generate_one(prefix_words)
    @markov[prefix_words].sample
  end

  # given the start prefix, generate words until EOF
  #
  def generate_all(start_prefix_words)
    words = start_prefix_words
    while tmp = generate_one(words[-1 * @num_prefix_words, @num_prefix_words])
      words << tmp
    end
    words.join
  end

  # do it, you know you want to
  #
  def destroy(text)
    analyze(text)
    generate_all(self.class.start_prefix(text, @num_prefix_words))
  end
end
