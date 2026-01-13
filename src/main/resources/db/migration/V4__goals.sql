-- V4__goals.sql
-- Metas financeiras

CREATE TABLE goals (
  id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  user_id BIGINT NOT NULL,
  name NVARCHAR(120) NOT NULL,
  target_amount DECIMAL(19,2) NOT NULL,
  target_date DATE NULL,
  status NVARCHAR(20) NOT NULL CONSTRAINT df_goals_status DEFAULT 'ACTIVE',
  created_at DATETIME2 NOT NULL CONSTRAINT df_goals_created_at DEFAULT SYSDATETIME(),
  CONSTRAINT fk_goals_user
    FOREIGN KEY (user_id) REFERENCES users(id)
);

ALTER TABLE goals
  ADD CONSTRAINT ck_goals_status
  CHECK (status IN ('ACTIVE','ACHIEVED','CANCELED'));

ALTER TABLE goals
  ADD CONSTRAINT ck_goals_target_positive
  CHECK (target_amount > 0);

CREATE INDEX ix_goals_user_id ON goals(user_id);
CREATE INDEX ix_goals_user_status ON goals(user_id, status);
