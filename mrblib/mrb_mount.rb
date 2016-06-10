class Mount
  class << self
    alias current_environ new
  end

  def mount(source, target, options={})
    flag = Mount::MS_MGC_VAL
    unless type = options[:type]
      raise ArgumentError, ":type must be specified"
    end

    __mount__(source, target, type, flag, nil)
  end

  def bind_mount(source, target)
    flag =  Mount::MS_MGC_VAL
    flag |= Mount::MS_BIND
    __mount__(source, target, "", flag, nil)
  end

  def make_private(target)
    flag = Mount::MS_PRIVATE
    __mount__("none", target, nil, flag, nil)
  end
end
