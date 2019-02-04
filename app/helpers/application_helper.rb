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
  
  def simple_time(time)                                                         #日付をJSTに変えて+0900の表記が邪魔な為日付を見やすくする。
    time.strftime("%Y-%m-%d %H:%M:%S")                                          #strftimeメソッドで表示させる日付時刻を秒までに設定。
  end
end