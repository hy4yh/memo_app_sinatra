# frozen_string_literal: true

require "csv"
require "securerandom"

class Memo
  attr_accessor :uuid, :title, :content

  def initialize(title, content)
    @uuid = SecureRandom.uuid.delete("-")
    @title = title
    @content = content
  end

  def save
    CSV.open("memo.csv", "a") do |memo|
      memo << [@uuid, @title.encode(universal_newline: true), @content.encode(universal_newline: true)]
    end
  end

  def self.all
    File.open("memo.csv", "w") unless File.exist?("memo.csv")
    CSV.read("memo.csv")
  end

  def self.find(uuid)
    CSV.foreach("memo.csv") do |row|
      return { uuid: row[0], title: row[1], content: row[2] } if row[0] == uuid
    end
  end

  def self.update(memo_hash)
    array = []
    CSV.foreach("memo.csv") do |row|
      if row[0] == memo_hash[:uuid]
        array << [row[0], memo_hash[:title].encode(universal_newline: true), memo_hash[:content].encode(universal_newline: true)]
      else
        array << [row[0], row[1], row[2]]
      end
    end
    write_csv(array)
  end

  def self.delete(uuid)
    array = []
    CSV.foreach("memo.csv") do |row|
      array << [row[0], row[1], row[2]] unless row[0] == uuid
    end
    write_csv(array)
  end

  private

    def self.write_csv(array)
      CSV.open("memo.csv", "w") do |csv|
        array.each do |row|
          csv << row
        end
      end
    end
end
