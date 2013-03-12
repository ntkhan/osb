class InvoiceBulkActionsService
  def initialize(options)
    @options ||= options
    @action_to_perform = @options[:commit]
  end

  def perform
    return method(@action_to_perform).call
  end

  def archive
    puts "Archiving..."
  end

  def destroy
    puts "

  end

  def recover_archived

  end

  def recover_deleted

  end

  def send_invoice

  end

  def enter_payment

  end


end