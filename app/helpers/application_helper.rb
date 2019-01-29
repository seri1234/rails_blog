module ApplicationHelper

  # ページごとの完全なタイトルを返します。
  def full_title(page_title = '')                                               #application.html.erbで使用
    base_title = "Kohei's blog"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end