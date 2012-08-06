class Channel
  def self.for_job(uid)
    "search:#{uid}"
  end
end
