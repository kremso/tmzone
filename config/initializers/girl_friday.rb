class GirlFridayProcessingError < StandardError
  attr_reader :job_id, :original_exception

  def initialize(job_id, original_exception)
    @job_id = job_id
    @original_exception = original_exception
  end
end

TORT_QUEUE = GirlFriday::WorkQueue.new(:tort, :size => 10, :error_handler => SearchWorker) do |msg|
  begin
    SearchWorker.perform(msg[:phrase], msg[:job_id])
  rescue => ex
    raise GirlFridayProcessingError.new(msg[:job_id], ex)
  end
end
