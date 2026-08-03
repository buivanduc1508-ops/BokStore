USE BOOKSTORE;
GO
IF COL_LENGTH('san_pham','author') IS NULL ALTER TABLE san_pham ADD author NVARCHAR(150) NULL;
IF COL_LENGTH('san_pham','publisher') IS NULL ALTER TABLE san_pham ADD publisher NVARCHAR(150) NULL;
IF COL_LENGTH('san_pham','views') IS NULL ALTER TABLE san_pham ADD views INT NOT NULL CONSTRAINT DF_san_pham_views DEFAULT 0;
IF COL_LENGTH('san_pham','sold') IS NULL ALTER TABLE san_pham ADD sold INT NOT NULL CONSTRAINT DF_san_pham_sold DEFAULT 0;
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_san_pham_search' AND object_id=OBJECT_ID('san_pham'))
    CREATE INDEX IX_san_pham_search ON san_pham(name, category_id, status) INCLUDE(price, quantity, publisher);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_hoa_don_user_status_date' AND object_id=OBJECT_ID('hoa_don'))
    CREATE INDEX IX_hoa_don_user_status_date ON hoa_don(user_id, order_status, created_at) INCLUDE(total_amount);
GO
