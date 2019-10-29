class Iterator
  def hasNext
    raise NotImplementedError.new("#{self.class}##{__method__} が実装されていません")
  end

  def next
    raise NotImplementedError.new("#{self.class}##{__method__} が実装されていません")
  end
end