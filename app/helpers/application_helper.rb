module ApplicationHelper
  # to add a active class to current link on main menu
  def nav_link(text, link)
    recognized = Rails.application.routes.recognize_path(link)
    if recognized[:controller] == params[:controller] && recognized[:action] == params[:action]
      content_tag(:li, :class => "active") do
        link_to(text, link)
      end
    else
      content_tag(:li) do
        link_to(text, link)
      end
    end
  end

  def custom_per_page
    content_tag(:select,
                options_for_select([1, 2, 3, 4], params[:per].to_i),
                :data => {
                    :remote => true,
                    :url => url_for(:action => action_name, :params => params)},
                    :style => "width:60px;"
    )
  end

  # helper function make a link to submit its parent form
  def link_to_submit(*args, &block)
    link_to_function (block_given? ? capture(&block) : args[0]), "jQuery(this).closest('form').submit();", args.extract_options!
  end
end
