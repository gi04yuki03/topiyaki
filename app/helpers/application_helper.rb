module ApplicationHelper

  BASE_TITLE = 'YAKITOPI'
  
  def page_title(sub_title = '')
    sub_title.blank? ? BASE_TITLE : "#{sub_title} - #{BASE_TITLE}"
  end
end
