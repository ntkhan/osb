module ItemsHelper
  def new_item id
    notice = <<-HTML
       <p>Item has been created successfully.</p>
       <ul>
         <li><a href="/items/new">Create another item</a></li>
         <li><a href="/items/new?id=#{id}">Create another by duplicating this item</a></li>
       </ul>
    HTML
    notice = notice.html_safe
  end
end
