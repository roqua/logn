# Logn

Why bother with complicated centralized logging servers with elastic searchers
when you have a powerful machine running idle on your desk, and you only have
a few million lines of logs anyway?

This gem is meant for those who are not web scale. You don't need to set up
any servers. Just point it at some log files, and we'll give you a nice
console where you can specify some filters to drill down to the lines
you want.

## Installation

    $ gem install logn

## Usage

    $ logn *.log

Right now, your log files need to be formatted like this:

    I, [2013-04-22T09:47:33.081972 #12790] ERROR -- : sending.application.area:status {"optional":"json hash","with":"extra event data"}

This is obviously the best log format ever, but pull requests that add support for customizable formats might be merged. ;)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
