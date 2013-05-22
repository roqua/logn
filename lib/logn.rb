# coding: utf-8
require "logn/version"
require 'ostruct'
require 'time'
require 'json'
require 'pry'
require 'terminfo'
require 'rainbow'

module Logn
  class Shell
    attr_reader :events

    def initialize(events)
      @events = events
    end

    def start
      binding.pry(quiet: true)
    end

    def filter(&block)
      @events.add_filter &block
    end

    def show
      formatter = EventFormatter.new(STDOUT)
      @events.each {|e| formatter.print e }
      nil
    end
  end

  class Events
    include Enumerable

    def initialize
      @events  = []
      @filters = []
    end

    def add(event)
      @events << event
    end

    def add_filter &block
      @filters << block
    end

    def matching
      @events.select do |event|
        @filters.all? {|filter| filter.call event }
      end
    end

    def each(*args, &block)
      matching.each(*args, &block)
    end

    def size
      return @events.size if @filters.empty?
      matching.size
    end
  end

  class EventFormatter
    attr_reader :output

    def initialize(output)
      @output = output
      @height, @width = TermInfo.screen_size
    end

    def print(event)
      output.print event.timestamp.to_s.color(:yellow)
      output.print ' '
      output.print event.sender
      output.print ':' + event.event if event.event
      output.print "\n"
    end
  end

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
      @event ||= (match[:event] and match[:event].gsub(/^:/, '').downcase.to_sym)
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
