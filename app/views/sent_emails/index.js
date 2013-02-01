jQuery('tbody#email_body').html('<%= escape_javascript render("sent_emails") %>');
jQuery('.paginator').html('<%= escape_javascript(paginate(@sent_emails, :remote => true).to_s) %>' +
    '<div class="paging_info"><%= page_entries_info @sent_emails %></div>');