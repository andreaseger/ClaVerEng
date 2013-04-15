#!/usr/bin/env ruby

$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..'))
require 'config/setup'
require 'lib/runner/special'

runner = Runner::Special.new(pretty: true)

runner.run(:simple, :bns, samplesize: 6000, dictionary_size: 400, classification: :function)
