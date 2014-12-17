[![Build Status](https://travis-ci.org/rickhull/loremarkov.svg?branch=master)](https://travis-ci.org/rickhull/loremarkov)
[![Gem Version](https://badge.fury.io/rb/loremarkov.svg)](http://badge.fury.io/rb/loremarkov)
[![Code Climate](https://codeclimate.com/github/rickhull/loremarkov/badges/gpa.svg)](https://codeclimate.com/github/rickhull/loremarkov)
[![Dependency Status](https://gemnasium.com/rickhull/loremarkov.svg)](https://gemnasium.com/rickhull/loremarkov)
[![Security Status](https://hakiri.io/github/rickhull/loremarkov/master.svg)](https://hakiri.io/github/rickhull/loremarkov/master)

Introduction
===

Need to generate text in a hurry?  This is the tool for you! With several sample texts built in, you can generate plausible sounding passages at the push of
a button.

Install
---
    $ gem install loremarkov

Lorem ipsum
---

    $ destroy

Usage
===
* [As a library] (https://rickhull.github.io/loremarkov/rocco/loremarkov.html)
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
    $ man ls | destroy 12

Inspiration
===
* Based upon Kernighan & Pike's *The Practice of Programming* Chapter 3
