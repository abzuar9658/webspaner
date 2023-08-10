module ErrorHandler
  def error_handler_wrapper(&block)
    yield block
  rescue StandardError => e
    errors << e.message
  end
end
