CREATE TABLE oauth_clients (
  client_id             VARCHAR(80)   NOT NULL,
  client_secret         VARCHAR(80),
  redirect_uri          VARCHAR(2000),
  grant_types           VARCHAR(80),
  scope                 VARCHAR(4000),
  user_id               VARCHAR(500),
  PRIMARY KEY (client_id)
);

CREATE TABLE oauth_access_tokens (
  access_token         VARCHAR(40)    NOT NULL,
  client_id            VARCHAR(80)    NOT NULL,
  user_id              VARCHAR(500),
  expires              TIMESTAMP      NOT NULL,
  scope                VARCHAR(4000),
  PRIMARY KEY (access_token)
);

CREATE TABLE oauth_authorization_codes (
  authorization_code  VARCHAR(40)    NOT NULL,
  client_id           VARCHAR(80)    NOT NULL,
  user_id             VARCHAR(500),
  redirect_uri        VARCHAR(2000),
  expires             TIMESTAMP      NOT NULL,
  scope               VARCHAR(4000),
  id_token            VARCHAR(1000),
  PRIMARY KEY (authorization_code)
);

CREATE TABLE oauth_refresh_tokens (
  refresh_token       VARCHAR(40)    NOT NULL,
  client_id           VARCHAR(80)    NOT NULL,
  user_id             VARCHAR(500),
  expires             TIMESTAMP      NOT NULL,
  scope               VARCHAR(4000),
  PRIMARY KEY (refresh_token)
);

CREATE TABLE oauth_users (
  username            VARCHAR(500),
  password            VARCHAR(80),
  first_name          VARCHAR(80),
  last_name           VARCHAR(80),
  email               VARCHAR(80),
  email_verified      BOOLEAN,
  scope               VARCHAR(4000)
);

CREATE TABLE oauth_scopes (
  scope               VARCHAR(80)  NOT NULL,
  is_default          BOOLEAN,
  PRIMARY KEY (scope)
);

INSERT INTO oauth_scopes (scope, is_default) VALUES ('student', 1), ('teacher', 0);

CREATE TABLE oauth_jwt (
  client_id           VARCHAR(80)   NOT NULL,
  subject             VARCHAR(80),
  public_key          VARCHAR(2000) NOT NULL
);

CREATE TABLE oauth_jti (
  issuer              VARCHAR(80)   NOT NULL,
  subject             VARCHAR(80),
  audiance            VARCHAR(80),
  expires             TIMESTAMP     NOT NULL,
  jti                 VARCHAR(2000) NOT NULL
);

CREATE TABLE oauth_public_keys (
  client_id            VARCHAR(80),
  public_key           VARCHAR(2000),
  private_key          VARCHAR(2000),
  encryption_algorithm VARCHAR(100) DEFAULT 'RS256'
);

CREATE TABLE difficulty_levels (
  name VARCHAR(32) NOT NULL,
  PRIMARY KEY (name)
);

INSERT INTO difficulty_levels (name) VALUES ('easy'), ('medium'), ('hard');

CREATE TABLE test_type (
  name VARCHAR(32) NOT NULL,
  PRIMARY KEY (name)
);

INSERT INTO test_type (name) VALUES ('listening'), ('reading'), ('speaking'), ('vocabulary'), ('writing');

CREATE TABLE test_results (
  type       VARCHAR(32)  NOT NULL,
  username   VARCHAR(500) NOT NULL,
  timestamp  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  accuracy   FLOAT        NOT NULL,
  difficulty VARCHAR(32)  NOT NULL,
  PRIMARY KEY (type, username, timestamp, difficulty)
);
