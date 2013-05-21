# coding: utf-8
require "logn/version"
require 'ostruct'
require 'time'
require 'json'
require 'yajl'

module Logn
  class Event
    LOG_LINE_REGEX = /^
                      (?<level>\w)
                      ,\s
                      \[
                        (?<timestamp>\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d.\d+)
                        \s
                        \#(?<pid>\d+)
                      \]
                      \s+
                      (?<severity>\w+)
                      \s--\s:\s
                      (?<sender>[\w.]+)
                      (?<event>:\w+)?
                      \s
                      (?<json>.*)
                      $/x

    def initialize(line)
      @line = line
    end

    def level
      match[:level]
    end

    def timestamp
      @timestamp ||= Time.iso8601(match[:timestamp])
    end

    def pid
      match[:pid]
    end

    def severity
      @severity ||= match[:severity].downcase.to_sym
    end

    def sender
      match[:sender]
    end

    def event
      @event ||= (match[:event] and match[:event].gsub(/^:/, ''))
    end

    def metadata
      return nil unless match[:json]
      @metadata ||= JSON.parse(match[:json])
    end

    private

    def match
      @match ||= @line.match(LOG_LINE_REGEX)
      raise "Could not parse #{line}" unless @match
      @match
    end
  end
end
