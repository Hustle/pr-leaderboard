class HashSerializer
  def self.dump(hash)
    hash.to_json
  end

  def self.load(hash)
    Hashie::Mash.new(hash || {})
  end
end
