class Hash
  def with(key, value)
    new_hash = self.clone
    new_hash[key] = value
    return new_hash
  end
end
