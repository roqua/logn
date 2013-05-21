# coding: utf-8
require 'logn'

describe 'parsing a log entry' do
  let(:line) { %(I, [2013-05-21T16:14:51.587433 #2313]  INFO -- : roqua.web:started {"uuid":"123","method":"GET","path":"/epd/patient/new_outcomes/6/scores","format":"html","controller":"epd/new_outcomes","action":"scores","status":200,"params":{"id":"6"},"session_id":"0012","session":{"logged_in_at":"2013-05-21T16:14:37+02:00","user_id":37},"duration":56.24,"view":40.91,"db":2.33}) }
  let(:entry) { Logn::Parser.new.parse(line) }

  it 'parses the level' do
    entry.level.should == 'I'
  end

  it 'parses the timestamp' do
    entry.timestamp.should == Time.local(2013, 05, 21, 16, 14, 51, 587433)
  end

  it 'parses the pid' do
    entry.pid.should == '2313'
  end

  it 'parses the severity' do
    entry.severity.should == 'INFO'
  end

  it 'parses the sender' do
    entry.sender.should == 'roqua.web'
  end

  it 'parses the event' do
    entry.event.should == 'started'
  end

  it 'parses the json hash' do
    entry.metadata.should == {
      "uuid"=> "123",
      "method"=>"GET",
      "path"=> "/epd/patient/new_outcomes/6/scores",
      "format"=>"html",
      "controller"=>"epd/new_outcomes",
      "action"=>"scores",
      "status"=>200,
      "params"=>{"id"=>"6"},
      "session_id"=>"0012",
      "session"=>{"logged_in_at"=>"2013-05-21T16:14:37+02:00","user_id"=>37},
      "duration"=>56.24,
      "view"=>40.91,
      "db"=>2.33
    }
  end

  it 'parses errors' do
    line = %(E, [2013-04-22T09:47:33.081972 #12790] ERROR -- : roqua.hl7.a19:failed {"exception":{},"message":"Connection timed out - connect(2)"})
    entry = Logn::Parser.new.parse(line)
    entry.level.should == 'E'
    entry.severity.should == 'ERROR'
  end
end