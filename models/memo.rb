require 'csv'

class Memo
  @@id = 0
  attr_accessor :memo_title, :memo_content

  def initialize (memo_title, memo_content)
    @memo_title = memo_title
    @memo_content = memo_content
  end

  def save
    @@id =+ 1
    CSV.open('memo.csv','a') do |memo|
     memo << [@@id, @memo_title, @memo_content]
    end
    return @@id, @memo_title, @memo_content
  end
end
