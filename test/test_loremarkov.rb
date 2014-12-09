require 'minitest/spec'
require 'minitest/autorun'
require 'loremarkov'

NUM_PREFIX = 3
LOREM_IPSUM = Loremarkov.sample_text 'lorem_ipsum'
LOREM_LEX = Loremarkov.lex LOREM_IPSUM
LOREM_SENTENCE = LOREM_IPSUM[/[^.]*\./]
LOREM_SENTENCE_WORDS = %w{
  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
  tempor incididunt ut labore et dolore magna aliqua.
}

describe Loremarkov do
  describe "Lorem ipsum" do
    describe "sample text" do
      it "must match test data" do
        # this works because the first Lorem tokens are all spaces
        LOREM_SENTENCE.must_equal LOREM_SENTENCE_WORDS.join(' ')
      end
    end

    describe "lex" do
      it "must provide expected prefixes" do
        LOREM_LEX.each.with_index { |token, i|
          break if i >= 36
          # this too works because all tokens are spaces
          token.must_equal (i % 2 == 0 ? LOREM_SENTENCE_WORDS[i/2] : ' ')
        }
      end
    end
  end
end
