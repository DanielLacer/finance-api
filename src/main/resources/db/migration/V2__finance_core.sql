-- V4__finance_core.sql
-- Core financeiro: accounts, categories, transactions

/* ACCOUNTS */
CREATE TABLE dbo.accounts (
  id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT pk_accounts PRIMARY KEY,
  user_id BIGINT NOT NULL,
  [name] NVARCHAR(80) NOT NULL,
  [type] NVARCHAR(20) NOT NULL,
  currency CHAR(3) NOT NULL CONSTRAINT df_accounts_currency DEFAULT 'BRL',
  opening_balance DECIMAL(19,2) NOT NULL CONSTRAINT df_accounts_opening_balance DEFAULT 0,
  created_at DATETIME2 NOT NULL CONSTRAINT df_accounts_created_at DEFAULT SYSDATETIME(),
  CONSTRAINT fk_accounts_user
    FOREIGN KEY (user_id) REFERENCES dbo.users(id)
);
GO

ALTER TABLE dbo.accounts
  ADD CONSTRAINT uq_accounts_user_name UNIQUE (user_id, [name]);
GO

ALTER TABLE dbo.accounts
  ADD CONSTRAINT ck_accounts_type
  CHECK ([type] IN ('CASH','BANK','CREDIT_CARD','INVESTMENT'));
GO

CREATE INDEX ix_accounts_user_id ON dbo.accounts(user_id);
GO


/* CATEGORIES */
CREATE TABLE dbo.categories (
  id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT pk_categories PRIMARY KEY,
  user_id BIGINT NOT NULL,
  [name] NVARCHAR(100) NOT NULL,
  [kind] NVARCHAR(20) NOT NULL,
  created_at DATETIME2 NOT NULL CONSTRAINT df_categories_created_at DEFAULT SYSDATETIME(),
  CONSTRAINT fk_categories_user
    FOREIGN KEY (user_id) REFERENCES dbo.users(id)
);
GO

ALTER TABLE dbo.categories
  ADD CONSTRAINT uq_categories_user_name UNIQUE (user_id, [name]);
GO

ALTER TABLE dbo.categories
  ADD CONSTRAINT ck_categories_kind
  CHECK ([kind] IN ('EXPENSE','INCOME','BOTH'));
GO

CREATE INDEX ix_categories_user_id ON dbo.categories(user_id);
GO


/* TRANSACTIONS */
CREATE TABLE dbo.transactions (
  id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT pk_transactions PRIMARY KEY,
  user_id BIGINT NOT NULL,
  account_id BIGINT NOT NULL,
  category_id BIGINT NOT NULL,
  [type] NVARCHAR(10) NOT NULL,
  amount DECIMAL(19,2) NOT NULL,
  description NVARCHAR(255) NULL,
  transaction_date DATE NOT NULL,
  created_at DATETIME2 NOT NULL CONSTRAINT df_transactions_created_at DEFAULT SYSDATETIME(),
  CONSTRAINT fk_transactions_user
    FOREIGN KEY (user_id) REFERENCES dbo.users(id),
  CONSTRAINT fk_transactions_account
    FOREIGN KEY (account_id) REFERENCES dbo.accounts(id),
  CONSTRAINT fk_transactions_category
    FOREIGN KEY (category_id) REFERENCES dbo.categories(id)
);
GO

ALTER TABLE dbo.transactions
  ADD CONSTRAINT ck_transactions_type
  CHECK ([type] IN ('INCOME','EXPENSE'));
GO

ALTER TABLE dbo.transactions
  ADD CONSTRAINT ck_transactions_amount_positive
  CHECK (amount > 0);
GO

-- Índices para dashboard e filtros
CREATE INDEX ix_transactions_user_date ON dbo.transactions(user_id, transaction_date);
GO
CREATE INDEX ix_transactions_user_category ON dbo.transactions(user_id, category_id);
GO
CREATE INDEX ix_transactions_user_account ON dbo.transactions(user_id, account_id);
GO