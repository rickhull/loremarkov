# **Loremarkov** uses Markov chains to generate plausible-sounding text, given
# an input corpus.  It comes with a few built-in sample texts.
#
# It is based upon Kernighan & Pike's *The Practice of Programming* Chapter 3
#
# Install Loremarkov with Rubygems:
#
#     gem install loremarkov
#
# Once installed, the `destroy` command can be used to generate plausible-
# sounding text.  The input text may be provided by filename, STDIN, or naming
# one of the built-in sample texts.
#
#     destroy lorem_ipsum
#     destroy ~/my_first_corpus.txt
#     man ls | destroy

class Loremarkov
  ##### TOKENS - These tokens are what splits the text into words.
  # In contrast to ruby's String#split, these tokens are included in the
  # resulting array.
  TOKENS = ["\n", "\t", ' ', "'", '"']

  ##### lex - Decompose text into an array of tokens and words
  # Words are merely the string of characters between the nearest two TOKENS
  # e.g.
  #
  #     lex %q{"Hello", he said.}
  #
  # becomes
  #
  #     - %q{"}      # TOKEN
  #     - %q{Hello}  # word
  #     - %q{"}      # TOKEN
  #     - %q{,}      # word
  #     - %q{ }      # TOKEN
  #     - %q{he}     # word
  #     - %q{ }      # TOKEN
  #     - %q{said.}  # word
  #
  # This operation can be losslessly reversed by calling #join on the resulting
  # array.
  # i.e. `lex(str).join == str`
  #
  def self.lex(str, tokens = TOKENS)
    final_ary = []
    word = ''
    # This code makes no attempt to deal with non-ASCII string encodings.
    # i.e.  byte-per-char
    str.each_byte { |b|
      # This byte is either a token, thereby ending the current word
      # or it is part of the current word
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


  ##### analyze - Generate a markov data structure
  # * Arrays of string for keys and values
  # * Keys are prefixes -- ordered word sequence of constant length
  # * Values are an accumulation of the next word after the prefix, however
  #   many times it may occur.
  # * e.g. If a prefix occurs twice, then the value will be an array of two
  #   words -- possibly the same word twice.
  def self.analyze(text, num_prefix_words)
    markov = {}
    words = lex(text)

    # Go through the possible valid prefixes.  Adding 1 gives you the final
    # key: *num_prefix_words* words with a nil value  -- signifying EOF
    (words.length - num_prefix_words + 1).times { |i|
      prefix_words = []
      num_prefix_words.times { |j| prefix_words << words[i + j] }
      # Set to empty array on a new prefix.
      # Add the target word, which will be nil on the last iteration
      markov[prefix_words] ||= []
      markov[prefix_words] << words[i + num_prefix_words]
    }
    markov
  end

  # Given the entire text, use an extremely conservative heuristic to grab only
  # the first chunk to pass to lex
  def self.start_prefix(text, num_prefix_words)
    lex(text[0, 999 * num_prefix_words])[0, num_prefix_words]
  end

  attr_reader :markov

  # More prefix_words means tighter alignment to original text
  def initialize(num_prefix_words)
    @num_prefix_words = num_prefix_words
    @markov = {}
  end

  # Generate Markov structure from text.
  # Text should have a definite end, not just a convenient buffer split.
  # This method may be called several times, but note that several EOFs
  # will be present in the markov structure, any one of which will trigger
  # a conclusion by #generate_all.
  def analyze(text)
    @markov.merge!(self.class.analyze(text, @num_prefix_words))
  end

  # Generate the next word for a given prefix
  def generate_one(prefix_words)
    @markov.fetch(prefix_words).sample
  end

  # Given the start prefix, generate words until EOF
  def generate_all(start_prefix_words)
    words = start_prefix_words
    while tmp = generate_one(words[-1 * @num_prefix_words, @num_prefix_words])
      words << tmp
    end
    words.join
  end

  # Do it, you know you want to
  def destroy(text)
    analyze(text)
    generate_all(self.class.start_prefix(text, @num_prefix_words))
  end
end
