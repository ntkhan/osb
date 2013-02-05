module TaxesHelper
  def new_tax id
    notice = <<-HTML
       <p>Tax has been created successfully.</p>
       <ul>
         <li><a href="/taxes/new">Create another tax</a></li>
         <li><a href="/taxes/new?id=#{id}">Create another by duplicating this tax</a></li>
       </ul>
    HTML
    notice = notice.html_safe
  end

  def taxes_archived ids
    notice = <<-HTML
     <p>#{ids.size} tax(es) have been archived. You can find them under
     <a href="taxes/filter_taxes?status=archived" data-remote="true">Archived</a> section on this page.</p>
     <p><a href='taxes/undo_actions?ids=#{ids.join(",")}&archived=true'  data-remote="true">Undo this action</a> to move archived taxes back to active.</p>
    HTML
    notice = notice.html_safe
  end

  def taxes_deleted ids
    notice = <<-HTML
     <p>#{ids.size} tax(es) have been deleted. You can find them under
     <a href="taxes/filter_items?status=deleted" data-remote="true">Deleted</a> section on this page.</p>
     <p><a href='taxes/undo_actions?ids=#{ids.join(",")}&deleted=true'  data-remote="true">Undo this action</a> to move deleted taxes back to active.</p>
    HTML
    notice = notice.html_safe
  end
end
