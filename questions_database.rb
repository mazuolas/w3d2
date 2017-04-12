require 'sqlite3'
require 'singleton'
require_relative 'user.rb'
require_relative 'question_like.rb'
require_relative 'reply.rb'
require_relative 'question_follow.rb'
require_relative 'question.rb'
require 'byebug'

class QuestionsDatabase < SQLite3::Database
  include Singleton
  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Datum
  # def initialize(type)
  #   @type = type
  # end

  def self.find_by_id(id)
    datum = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{self.table}
      WHERE
        id = ?
    SQL

    self.new(datum[0])
  end
end
