Introduction
===

Need to generate text in a hurry?  This is the tool for you!

With several sample texts built in, you can generate plausible sounding
passages, ready for copy / pasting, at the push of a button.  Just install the
gem and run `destroy` for the default *lorem ipsum* paragraph.

Usage
===
* As a library
* Via `destroy` executable

Install
---
    gem install loremarkov

Destroy (executable)
---
* Accepts input via filename or STDIN
* Also recognizes sample texts: lorem_ipsum, epigenetics, oslo_accords
* Secondary parameter for num_prefix_words

    $ destroy # or destroy lorem_ipsum
    $ destroy epigenetics
    $ destroy oslo_accords 3
    $ destroy ~/my_first_corpus.txt
    $ man ls | destroy 6

Inspiration
===
* Based upon Kernighan & Pike's *The Practice of Programming* Chapter 3
