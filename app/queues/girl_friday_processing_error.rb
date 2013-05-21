class GirlFridayProcessingError < StandardError
  attr_reader :job_id, :original_exception

  def initialize(job_id, original_exception)
    @job_id = job_id
    @original_exception = original_exception
  end
end
