require_relative 'questions_database.rb'

class Reply

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
    @body = options['body']
    @parent = options['parent']
  end

  def save
    if @id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, @question_id, @user_id, @body, @parent)
      INSERT INTO
        replies (question_id, user_id, body, parent)
      VALUES
        (?,?,?,?)
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL, @question_id, @user_id, @body, @parent, @id)
      UPDATE
        replies
      SET
        question_id = ?, user_id = ?, body = ?, parent = ?
      WHERE
        id = ?
      SQL
    end
  end

  def self.find_by_id(id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      replies
    WHERE
      id = ?
    SQL
    Reply.new(reply[0])
  end

  def self.find_by_user_id(user_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      *
    FROM
      replies
    WHERE
      user_id = ?

    SQL
    replies.map { |reply| Reply.new(reply) }
  end

  def self.find_by_question_id(question_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL

    replies.map { |reply| Reply.new(reply) }
  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    Reply.find_by_id(@parent)
  end

  def child_replies
    replies = QuestionsDatabase.instance.execute(<<-SQL, @id)
    SELECT
      *
    FROM
      replies
    WHERE
      parent = ?
    SQL

    replies.map { |reply| Reply.new(reply) }
  end
end
