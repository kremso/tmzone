class Mark
  attr_accessor :name, :illustration_url, :registration_number, :owner,
    :application_number, :application_date, :registration_date, :valid_until,
    :detail_url, :status, :incomplete
  attr_reader :classes

  class NiceClass < Struct.new(:code, :description); end

  def initialize(attributes = [])
    attributes.each do |name, value|
      send("#{name}=", value)
    end
    @classes = []
  end

  def add_class(nice_code, nice_description)
    @classes << NiceClass.new(nice_code, nice_description)
  end
end
