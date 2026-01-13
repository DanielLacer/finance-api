-- V3__budgets.sql
-- Orçamento mensal por categoria

CREATE TABLE dbo.budgets (
  id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  user_id BIGINT NOT NULL,
  category_id BIGINT NOT NULL,
  year INT NOT NULL,
  month INT NOT NULL,
  limit_amount DECIMAL(19,2) NOT NULL,
  created_at DATETIME2 NOT NULL CONSTRAINT df_budgets_created_at DEFAULT SYSDATETIME(),
  CONSTRAINT fk_budgets_user
    FOREIGN KEY (user_id) REFERENCES dbo.users(id),
  CONSTRAINT fk_budgets_category
    FOREIGN KEY (category_id) REFERENCES dbo.categories(id)
);

ALTER TABLE budgets
  ADD CONSTRAINT ck_budgets_month
  CHECK (month BETWEEN 1 AND 12);

ALTER TABLE budgets
  ADD CONSTRAINT ck_budgets_limit_positive
  CHECK (limit_amount > 0);

ALTER TABLE budgets
  ADD CONSTRAINT uq_budgets_user_category_year_month
  UNIQUE (user_id, category_id, year, month);

CREATE INDEX ix_budgets_user_year_month ON budgets(user_id, year, month);
CREATE INDEX ix_budgets_user_category ON budgets(user_id, category_id);
