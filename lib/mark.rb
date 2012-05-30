class Mark
  attr_accessor :name, :illustration_url, :registration_number, :owner, :application_number,
    :application_date, :registration_date, :classes, :products_and_services,
    :valid_until, :detail_url

  def initialize(attributes)
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
end
