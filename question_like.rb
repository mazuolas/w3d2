require_relative 'questions_database.rb'

class QuestionLike
  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def self.likers_for_question(question_id)
    likers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      question_likes
    JOIN
      users on users.id = question_likes.user_id
    WHERE
      question_id = ?
    SQL
    likers.map { |liker| User.new(liker) }
  end

  def self.num_likes_for_question_id(question_id)
    likers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      COUNT(users.id) AS num_likes
    FROM
      question_likes
    LEFT JOIN
      users on users.id = question_likes.user_id
    WHERE
      question_id = ?
    GROUP BY
      question_id
    SQL
    return 0 if likers.empty?
    likers[0]['num_likes']
  end

  def self.liked_questions_for_user_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      JOIN
        question_likes ON questions.id = question_likes.question_id
      JOIN
        users ON users.id = question_likes.user_id
      WHERE
        users.id = ?
    SQL

    questions.map { |question| Question.new(question) }
  end

  def self.most_liked_questions(n)
    questions = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        *
      FROM
        questions
      LEFT JOIN
        question_likes ON questions.id = question_likes.question_id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(question_likes.user_id) DESC
      LIMIT
        ?
    SQL

    questions.map { |question| Question.new(question) }
  end
end
