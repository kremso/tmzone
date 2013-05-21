TORT_QUEUE = LazyTortQueue.define(:tort, :size => 10, :error_handler => SearchWorker) do |msg|
  begin
    SearchWorker.perform(msg[:phrase], msg[:job_id])
  rescue => ex
    raise GirlFridayProcessingError.new(msg[:job_id], ex)
  end
end
