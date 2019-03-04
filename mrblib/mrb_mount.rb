module Mount
  def self.mount(source, target, options={})
    unless type = options[:type]
      raise ArgumentError, ":type must be specified"
    end
    data = options[:options]

    flag =  MS_MGC_VAL
    flag |= parse_flags(options)

    __mount__(source, target, type, flag, data)
  end

  def self.bind_mount(source, target, options={})
    data = options[:options]

    flag =  MS_MGC_VAL
    flag |= MS_BIND
    flag |= parse_flags(options)

    __mount__(source, target, "", flag, data)

    if options[:readonly]
      remount(target, readonly: true, bind: true)
    end
  end

  def self.make_private(target)
    flag = MS_PRIVATE
    __mount__("none", target, nil, flag, nil)
  end

  def self.make_rprivate(target)
    flag = MS_REC | MS_PRIVATE
    __mount__("none", target, nil, flag, nil)
  end

  def self.make_rslave(target)
    flag = MS_REC | MS_SLAVE
    __mount__("none", target, nil, flag, nil)
  end

  def self.remount(target, options={})
    data = options[:options]

    flag =  MS_MGC_VAL | MS_REMOUNT
    flag |= parse_flags(options)
    __mount__("none", target, nil, flag, data)
  end

  private
  def self.parse_flags(options)
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

    if options[:nosuid]
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
