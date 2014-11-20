-- clearly don't do this in a real project, this is just for convenience here:
CREATE USER cowboy WITH PASSWORD 'cowboy';

-- our basic aggregate root:
CREATE TABLE users (
  id         serial primary key,
  name       text,
  email      text unique
);

GRANT SELECT,INSERT,UPDATE,DELETE ON users TO cowboy;
GRANT SELECT,USAGE ON users_id_seq TO cowboy;

INSERT INTO users (name, email) VALUES ('Alice', 'alice@email.com');
INSERT INTO users (name, email) VALUES ('Bob', 'bob@email.com');
INSERT INTO users (name, email) VALUES ('Chris', 'chris@email.com');
INSERT INTO users (name, email) VALUES ('Deborah', 'deborah@gmail.com');
