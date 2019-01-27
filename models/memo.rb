require 'csv'
require 'securerandom'

class Memo
  attr_accessor :uuid, :title, :content

  def initialize(title, content)
    @uuid = SecureRandom.uuid.delete("-")
    @title = title
    @content = content
  end

  def save
    CSV.open('memo.csv','a') do |memo|
      memo << [@uuid, @title.encode(universal_newline: true), @content.encode(universal_newline: true)]
    end
  end

  def self.all
    CSV.read("memo.csv")
  end

  def self.find(uuid)
    CSV.foreach("memo.csv") do |row|
      if row[0] == uuid
        return {title: row[1], content: row[2]}
      end
    end
  end
end
