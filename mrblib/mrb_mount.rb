class Mount
  class << self
    alias current_environ new
  end

  def mount(source, target, options={})
    unless type = options[:type]
      raise ArgumentError, ":type must be specified"
    end

    flag =  MS_MGC_VAL
    flag |= parse_flags(options)

    __mount__(source, target, type, flag, nil)
  end

  def bind_mount(source, target, options={})
    flag =  MS_MGC_VAL
    flag |= MS_BIND
    flag |= parse_flags(options)

    __mount__(source, target, "", flag, nil)

    if options[:readonly]
      remount(target, readonly: true, bind: true)
    end
  end

  def make_private(target)
    flag = MS_PRIVATE
    __mount__("none", target, nil, flag, nil)
  end

  def remount(target, options={})
    flag =  MS_MGC_VAL | MS_REMOUNT
    flag |= parse_flags(options)
    __mount__("none", target, nil, flag, nil)
  end

  private
  def parse_flags(options)
    if options.is_a? Integer
      return options
    end

    flag = 0
    if options[:bind]
      flag |= MS_BIND
    end

    if options[:readonly]
      flag |= MS_RDONLY
    end

    if options[:nosuid)]
      flag |= MS_NOSUID
    end

    if options[:noexec]
      flag |= MS_NOEXEC
    end

    if options[:remount]
      flag |= MS_REMOUNT
    end

    return flag
  end
end
