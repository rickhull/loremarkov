class MarkovText
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

  # given the entire text, use a heuristic to grab only the first chunk to pass to lex
  #
  def self.start_prefix(text, num_prefix_words)
    char_per_word = 20
    token_frequency = 0.5
    min_length = 60
    length = char_per_word * (num_prefix_words * (1 - token_frequency)).ceil
    fragment = text[0, [length, min_length].max]
    lex(fragment)[0, num_prefix_words]
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

if __FILE__ == $0
  $stdout.sync = true
  oslo_accords = <<WIKIPEDIA
The Oslo Accords, officially called the Declaration of Principles on Interim Self-Government Arrangements or Declaration of Principles (DOP) was a milestone in the Israeli-Palestinian conflict. It was the first direct, face-to-face agreement between Israel and political representatives of Palestinians. It was the first time that some Palestinian factions publicly acknowledged Israel's right to exist. It was intended to be a framework for the future relations between Israel and the anticipated Palestinian state, when all outstanding final status issues between the two states would be addressed and resolved in one agreement.

The Accords were finalized in Oslo, Norway on 20 August 1993, and subsequently officially signed at a public ceremony in Washington D.C. on 13 September 1993, with Yasser Arafat signing for the Palestine Liberation Organization and Prime Minister Yitzhak Rabin signing for the State of Israel. It was witnessed by Warren Christopher for the United States and Andrei Kozyrev for Russia, in the presence of US President Bill Clinton.

The Oslo Accords were a framework for the future relations between the two parties. The Accords provided for the creation of a Palestinian Authority. The Palestinian Authority would have responsibility for the administration of the territory under its control. The Accords also called for the withdrawal of the Israel Defence Forces from parts of the Gaza Strip and West Bank.

It was anticipated that this arrangement would last for a five-year interim period during which a permanent agreement would be negotiated (beginning no later than May 1996). Permanent issues such as Jerusalem, Palestinian refugees, Israeli settlements, security and borders were deliberately left to be decided at a later stage. Interim self-government was to be granted by Israel in phases.

Support for the Accords, of the concessions made and the process were not free from criticism. The repeated public posturing of all sides has discredited the process, not to mention putting into question the possibility of achieving peace, at least in the short-term. The momentum towards peaceful relations between Israel and the Palestinians as demonstrated by the signing of the Oslo Accords has been seriously jolted by the outbreak of the Second Intifada in 2000.

Further strain was put on the process after Hamas won 2006 Palestinian elections. Although offering Israel a number of longterm ceasefires and accepting the 2002 Arab Peace Initiative, Hamas has repeatedly refused to officially recognise Israel,[1] to renounce violent resistance, or accept some agreements previously made by the Palestinian Authority, claiming it is being held to an unfair standard and points out the fact that Israel has not recognized a Palestinian state, renounced violence or lived up to all pledges it has made during previous negotiations. Hamas has always renounced the Oslo Accords.
WIKIPEDIA

epigenetics = <<INTARWEB
Anyone who studied a little genetics in high school has heard of adenine, thymine, guanine and cytosine -- the A,T,G and C that make up the DNA code. But those are not the whole story. The rise of epigenetics in the past decade has drawn attention to a fifth nucleotide, 5-methylcytosine (5-mC), that sometimes replaces cytosine in the famous DNA double helix to regulate which genes are expressed. And now there's a sixth. In experiments to be published online Thursday by Science, researchers reveal an additional character in the mammalian DNA code, opening an entirely new front in epigenetic research.

The work, conducted in Nathaniel Heintz's Laboratory of Molecular Biology at The Rockefeller University, suggests that a new layer of complexity exists between our basic genetic blueprints and the creatures that grow out of them. "This is another mechanism for regulation of gene expression and nuclear structure that no one has had any insight into," says Heintz, who is also a Howard Hughes Medical Institute investigator. "The results are discrete and crystalline and clear; there is no uncertainty. I think this finding will electrify the field of epigenetics."

Genes alone cannot explain the vast differences in complexity among worms, mice, monkeys and humans, all of which have roughly the same amount of genetic material. Scientists have found that these differences arise in part from the dynamic regulation of gene expression rather than the genes themselves. Epigenetics, a relatively young and very hot field in biology, is the study of nongenetic factors that manage this regulation.

One key epigenetic player is DNA methylation, which targets sites where cytosine precedes guanine in the DNA code. An enzyme called DNA methyltransferase affixes a methyl group to cytosine, creating a different but stable nucleotide called 5-methylcytosine. This modification in the promoter region of a gene results in gene silencing.

Some regional DNA methylation occurs in the earliest stages of life, influencing differentiation of embryonic stem cells into the different cell types that constitute the diverse organs, tissues and systems of the body. Recent research has shown, however, that environmental factors and experiences, such as the type of care a rat pup receives from its mother, can also result in methylation patterns and corresponding behaviors that are heritable for several generations. Thousands upon thousands of scientific papers have focused on the role of 5-methylcytosine in development.

The discovery of a new nucleotide may make biologists rethink their approaches to investigating DNA methylation. Ironically, the latest addition to the DNA vocabulary was found by chance during investigations of the level of 5-methylcytosine in the very large nuclei of Purkinje cells, says Skirmantas Kriaucionis, a postdoctoral associate in the Heintz lab, who did the research. "We didn't go looking for this modification," he says. "We just found it."

Kriaucionis was working to compare the levels of 5-methylcytosine in two very different but connected neurons in the mouse brain . Purkinje cells, the largest brain cells, and granule cells, the most numerous and among the smallest. Together, these two types of cells coordinate motor function in the cerebellum. After developing a new method to separate the nuclei of individual cell types from one another, Kriaucionis was analyzing the epigenetic makeup of the cells when he came across substantial amounts of an unexpected and anomalous nucleotide, which he labeled 'x.'

It accounted for roughly 40 percent of the methylated cytosine in Purkinje cells and 10 percent in granule neurons. He then performed a series of tests on 'x,' including mass spectrometry, which determines the elemental components of molecules by breaking them down into their constituent parts, charging the particles and measuring their mass-to-charge ratio. He repeated the experiments more than 10 times and came up with the same result: x was 5-hydroxymethylcytosine, a stable nucleotide previously observed only in the simplest of life forms, bacterial viruses. A number of other tests showed that 'x' could not be a byproduct of age, DNA damage during the cell-type isolation procedure or RNA contamination. "It's stable and it's abundant in the mouse and human brain," Kriaucionis says. "It's really exciting."

What this nucleotide does is not yet clear. Initial tests suggested that it may play a role in demethylating DNA, but Kriaucionis and Heintz believe it may have a positive role in regulating gene expression as well. The reason that this nucleotide had not been seen before, the researchers say, is because of the methodologies used in most epigenetic experiments. Typically, scientists use a procedure called bisulfite sequencing to identify the sites of DNA methylation. But this test cannot distinguish between 5-hydroxymethylcytosine and 5-methylcytosine, a shortcoming that has kept the newly discovered nucleotide hidden for years, the researchers say. Its discovery may force investigators to revisit earlier work. The Human Epigenome Project, for example, is in the process of mapping all of the sites of methylation using bisulfite sequencing. "If it turns out in the future that (5-hydroxymethylcytosine and 5-methylcytosine) have different stable biological meanings, which we believe very likely, then epigenome mapping experiments will have to be repeated with the help of new tools that would distinguish the two," says Kriaucionis.

Providing further evidence for their case that 5-hydroxymethylcytosine is a serious epigenetic player, a second paper to be published in Science by an independent group at Harvard reveals the discovery of genes that produce enzymes that specifically convert 5-methylcytosine into 5-hydroxymethylcytosine. These enzymes may work in a way analogous to DNA methyltransferase, suggesting a dynamic system for regulating gene expression through 5-hydroxymethylcytosine. Kriaucionis and Heintz did not know of the other group's work, led by Anjana Rao, until earlier this month. "You look at our result, and the beautiful studies of the enzymology by Dr. Rao's group, and realize that you are at the tip of an iceberg of interesting biology and experimentation," says Heintz, a neuroscientist whose research has not focused on epigenetics in the past. "This finding of an enzyme that can convert 5-methylcytosine to 5-hydroxymethylcytosine establishes this new epigenetic mark as a central player in the field."

Kriaucionis is now mapping the sites where 5-hydroxymethylcytosine is present in the genome, and the researchers plan to genetically modify mice to under- or overexpress the newfound nucleotide in specific cell types in order to study its effects. "This is a major discovery in the field, and it is certain to be tied to neural function in a way that we can decipher," Heintz says.
INTARWEB

  text = oslo_accords#epigenetics
  num_prefixes = 5

  filename = ARGV.first
  if filename
    print "reading #{filename} ..."
    num_prefixes = (ARGV[1] || num_prefixes).to_i
    begin
      text = File.readlines(filename).join
      puts "DONE"
    rescue Exception => e
      puts "ERROR"
      puts e
    end
  end
  print "generating markov structure for #{num_prefixes} prefix words ..."
  m = MarkovText.new(num_prefixes)
  m.analyze(text)
  puts "DONE"
  puts "#{m.markov.keys.length} keys"
  puts "generating new text ..."
  puts m.generate_all(m.class.start_prefix(text[0, 999], num_prefixes))
end
