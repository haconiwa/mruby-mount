# mruby-mount   [![Build Status](https://travis-ci.org/haconiwa/mruby-mount.svg?branch=master)](https://travis-ci.org/haconiwa/mruby-mount)

Filesystem mount API for mruby

## install by mrbgems

- add conf.gem line to `build_config.rb`

```ruby
MRuby::Build.new do |conf|

    # ... (snip) ...

  conf.gem :github => 'haconiwa/mruby-mount'
end
```

## example

```ruby
m = Mount.new
# => #<Mount:0xc80b90>
m.make_private("/")
# => 0
m.bind_mount("/var/lib/myroot", "/var/lib/newroot")
# => 0
m.umount("/var/lib/newroot")
# => 0
m.mount("proc", "/proc", type: "proc")
# => 0
```

### options supported

* `noexec`, `nosuid`, `readonly` `remount` are supported (some of which are untested) in `mount/bind_mount`.

## Restrictions

This mgem may work only Linux.

## License

under the MIT License:
- see LICENSE file
