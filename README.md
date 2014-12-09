Introduction
===

Need to generate text in a hurry?  This is the tool for you!

With several sample texts built in, you can generate plausible sounding
passages, ready for copy / pasting, at the push of a button.  Just install the
gem and run `destroy` for the default *lorem ipsum* paragraph.

Install
---
    gem install loremarkov

Usage
===
* As a library (see [bin/destroy](https://github.com/rickhull/loremarkov/blob/master/bin/destroy) for an example)
* Via `destroy` executable

bin/destroy
---
* Accepts input via filename or STDIN
* Also recognizes sample texts:
  - lorem_ipsum
  - epigenetics
  - oslo_accords
* Provide a secondary parameter to control num_prefix_words

Examples
---
    $ destroy # or destroy lorem_ipsum
    $ destroy epigenetics
    $ destroy oslo_accords 3
    $ destroy ~/my_first_corpus.txt
    $ man ls | destroy 6

Inspiration
===
* Based upon Kernighan & Pike's *The Practice of Programming* Chapter 3
