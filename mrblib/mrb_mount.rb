class Mount
  class << self
    alias current_environ new
  end
end
