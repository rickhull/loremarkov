require 'minitest/spec'
require 'minitest/autorun'
require 'loremarkov'

NUM_PREFIX = 3
LOREM_IPSUM = Loremarkov.sample_text 'lorem_ipsum'
LOREM_LEX = Loremarkov.lex LOREM_IPSUM
LOREM_SENTENCE = %w{
  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
  tempor incididunt ut labore et dolore magna aliqua.
}

describe Loremarkov do
  describe "Lorem ipsum" do
    @foo = 5
    @foo.must_equal 5
  end
end
