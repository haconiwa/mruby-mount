# mruby-mount   [![Build Status](https://travis-ci.org/udzura/mruby-mount.svg?branch=master)](https://travis-ci.org/udzura/mruby-mount)
Mount class
## install by mrbgems
- add conf.gem line to `build_config.rb`

```ruby
MRuby::Build.new do |conf|

    # ... (snip) ...

    conf.gem :github => 'udzura/mruby-mount'
end
```
## example
```ruby
p Mount.hi
#=> "hi!!"
t = Mount.new "hello"
p t.hello
#=> "hello"
p t.bye
#=> "hello bye"
```

## License
under the MIT License:
- see LICENSE file
