# coding: utf-8
require "logn/version"
require 'ostruct'
require 'time'
require 'json'

module Logn
  class Parser
    def initialize
      @regex = /^
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
    end

    def parse(line)
      match = line.match(@regex)
      raise "Could not parse #{line}" unless match

      OpenStruct.new level: match[:level],
                     timestamp: Time.iso8601(match[:timestamp]),
                     pid: match[:pid],
                     severity: match[:severity],
                     sender: match[:sender],
                     event: parse_event(match[:event]),
                     metadata: parse_metadata(match[:json])
    end

    private

    def parse_event(event)
      return nil unless event
      event.gsub(/^:/, '')
    end

    def parse_metadata(json)
      return nil unless json
      JSON.parse(json)
    end
  end
end
