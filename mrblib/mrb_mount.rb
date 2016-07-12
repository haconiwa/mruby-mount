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
  end

  def make_private(target)
    flag = MS_PRIVATE
    __mount__("none", target, nil, flag, nil)
  end

  private
  def parse_flags(options)
    if options.is_a? Integer
      return options
    end

    flag = 0
    if options.delete(:readonly)
      flag |= MS_RDONLY
    end

    if options.delete(:nosuid)
      flag |= MS_NOSUID
    end

    if options.delete(:noexec)
      flag |= MS_NOEXEC
    end

    if options.delete(:remount)
      flag |= MS_REMOUNT
    end

    return flag
  end
end
