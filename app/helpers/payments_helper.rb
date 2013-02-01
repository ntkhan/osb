module PaymentsHelper
  def payments_archived ids
    notice = <<-HTML
     <p>#{ids.size} payment(s) have been archived. You can find them under
     <a href="payments/filter_payments?status=archived" data-remote="true">Archived</a> section on this page.</p>
     <p><a href='payments/undo_actions?ids=#{ids.join(",")}&archived=true'  data-remote="true">Undo this action</a> to move archived payments back to active.</p>
    HTML
    notice = notice.html_safe
  end

  def payments_deleted ids
    notice = <<-HTML
     <p>#{ids.size} payment(s) have been deleted. You can find them under
     <a href="payments/filter_payments?status=deleted" data-remote="true">Deleted</a> section on this page.</p>
     <p><a href='payments/undo_actions?ids=#{ids.join(",")}&deleted=true'  data-remote="true">Undo this action</a> to move deleted payments back to active.</p>
    HTML
    notice = notice.html_safe
  end
end
