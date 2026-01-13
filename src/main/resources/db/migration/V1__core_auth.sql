-- V1__core_auth.sql
-- Core de autenticação: users, oauth_identities, refresh_tokens

CREATE TABLE users (
  id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  email NVARCHAR(255) NOT NULL,
  password_hash NVARCHAR(255) NULL,
  name NVARCHAR(120) NOT NULL,
  avatar_url NVARCHAR(512) NULL,
  status NVARCHAR(20) NOT NULL CONSTRAINT df_users_status DEFAULT 'ACTIVE',
  created_at DATETIME2 NOT NULL CONSTRAINT df_users_created_at DEFAULT SYSDATETIME(),
  updated_at DATETIME2 NULL
);

ALTER TABLE users
  ADD CONSTRAINT uq_users_email UNIQUE (email);

ALTER TABLE users
  ADD CONSTRAINT ck_users_status
  CHECK (status IN ('ACTIVE','DISABLED'));


CREATE TABLE oauth_identities (
  id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  user_id BIGINT NOT NULL,
  provider NVARCHAR(30) NOT NULL,
  provider_user_id NVARCHAR(100) NOT NULL,
  email NVARCHAR(255) NULL,
  created_at DATETIME2 NOT NULL CONSTRAINT df_oauth_identities_created_at DEFAULT SYSDATETIME(),
  CONSTRAINT fk_oauth_identities_user
    FOREIGN KEY (user_id) REFERENCES users(id)
);

ALTER TABLE oauth_identities
  ADD CONSTRAINT uq_oauth_provider_user UNIQUE (provider, provider_user_id);


CREATE TABLE refresh_tokens (
  id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  user_id BIGINT NOT NULL,
  token_hash NVARCHAR(255) NOT NULL,
  expires_at DATETIME2 NOT NULL,
  revoked_at DATETIME2 NULL,
  created_at DATETIME2 NOT NULL CONSTRAINT df_refresh_tokens_created_at DEFAULT SYSDATETIME(),
  CONSTRAINT fk_refresh_tokens_user
    FOREIGN KEY (user_id) REFERENCES users(id)
);

ALTER TABLE refresh_tokens
  ADD CONSTRAINT uq_refresh_tokens_token_hash UNIQUE (token_hash);

-- Índices úteis
CREATE INDEX ix_oauth_identities_user_id ON oauth_identities(user_id);
CREATE INDEX ix_refresh_tokens_user_id ON refresh_tokens(user_id);
CREATE INDEX ix_refresh_tokens_expires_at ON refresh_tokens(expires_at);
