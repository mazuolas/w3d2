DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  parent INTEGER,
  body TEXT NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (parent) REFERENCES replies(id)
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Mark', 'Azuolas'),
  ('Eric', 'Mossman');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('Weeks', 'How many weeks is a a/A', (SELECT id FROM users WHERE fname = 'Eric')),
  ('Assessments', 'How many assessments are there?', (SELECT id FROM users WHERE fname = 'Mark'));

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Mark'), (SELECT id FROM questions WHERE title = 'Weeks'));

INSERT INTO
  replies (question_id, user_id, parent, body)
VALUES
  ((SELECT id FROM questions WHERE title = 'Weeks'), (SELECT id FROM users WHERE fname = 'Mark'), null, 'It''s 12 weeks!'),
  ((SELECT id FROM questions WHERE title = 'Weeks'), (SELECT id FROM users WHERE fname = 'Eric'), 1, 'Thanks!');

INSERT INTO
  question_likes(user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Mark'), (SELECT id FROM questions WHERE title = 'Weeks'));
