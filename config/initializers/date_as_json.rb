class Date
  def as_json(options = {})
    strftime('%d.%m.%Y')
  end
end
