module ItemsHelper
  def new_item id
    notice = <<-HTML
       <p>Item has been created successfully.</p>
       <ul>
         <li><a href="/items/new">Create another item</a></li>
        <!-- <li><a href="/items/new?id=#{id}">Create another by duplicating this item</a></li> -->
       </ul>
    HTML
    notice = notice.html_safe
  end

  def items_archived ids
    notice = <<-HTML
     <p>#{ids.size} item(s) have been archived. You can find them under
     <a href="items/filter_items?status=archived" data-remote="true">Archived</a> section on this page.</p>
     <p><a href='items/undo_actions?ids=#{ids.join(",")}&archived=true'  data-remote="true">Undo this action</a> to move archived items back to active.</p>
    HTML
    notice = notice.html_safe
  end

  def items_deleted ids
    notice = <<-HTML
     <p>#{ids.size} item(s) have been deleted. You can find them under
     <a href="items/filter_items?status=deleted" data-remote="true">Deleted</a> section on this page.</p>
     <p><a href='items/undo_actions?ids=#{ids.join(",")}&deleted=true'  data-remote="true">Undo this action</a> to move deleted items back to active.</p>
    HTML
    notice = notice.html_safe
  end

end
