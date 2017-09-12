# mruby-mount [![Build Status](https://travis-ci.org/haconiwa/mruby-mount.svg?branch=master)](https://travis-ci.org/haconiwa/mruby-mount)

Filesystem mount API for mruby

## install via mrbgems

- add conf.gem line to `build_config.rb`

```ruby
MRuby::Build.new do |conf|

  # ... (snip) ...

  conf.gem :github => 'haconiwa/mruby-mount'
end
```

## example

```ruby
Mount.make_private("/")
# => 0
Mount.bind_mount("/var/lib/myroot", "/var/lib/newroot")
# => 0
Mount.umount("/var/lib/newroot")
# => 0
Mount.mount("proc", "/proc", type: "proc")
# => 0
```

### options supported

* `noexec`, `nosuid`, `readonly` `remount` are supported (some of which are untested) in `mount/bind_mount`.

## Restrictions

This mgem may work only Linux.

## Formatter

```
rake format
```

## License

under the MIT License:
- see LICENSE file
