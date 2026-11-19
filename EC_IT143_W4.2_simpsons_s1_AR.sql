-- Question: What are the names, job titles, and credit card transaction amounts for each family member by joining Family_Data and Planet_Express?

--Answer: 1. Join Family_Data and Planet_Express on Member_ID = Card_Member to pull member details and transaction fields.
-- 2. Save the join logic as a reusable View (vw_simpsons_transactions).
-- 3. Create a physical summary table (dbo.sum_simpsons_transactions) from the View.
-- 4. Automate truncating and reloading the summary table using a stored procedure (usp_load_simpsons_transactions).


SELECT TOP 10
    f.Member_ID,
    f.Name,
    f.Job_Title,
    t.Date,
    t.Description,
    t.Amount,
    t.Category
FROM Family_Data f
JOIN Planet_Express t
    ON f.Member_ID = t.Card_Member
ORDER BY t.Date DESC;
    
-- Step 4: Create a reusable View
IF OBJECT_ID('dbo.vw_simpsons_transactions', 'V') IS NOT NULL
    DROP VIEW dbo.vw_simpsons_transactions;
GO

CREATE VIEW dbo.vw_simpsons_transactions AS
SELECT
    f.Member_ID,
    f.Name,
    f.Job_Title,
    t.Date,
    t.Description,
    t.Amount,
    t.Category
FROM Family_Data f
JOIN Planet_Express t
    ON f.Member_ID = t.Card_Member;
GO


IF OBJECT_ID('dbo.sum_simpsons_transactions', 'U') IS NOT NULL
    DROP TABLE dbo.sum_simpsons_transactions;
GO

SELECT *
INTO dbo.sum_simpsons_transactions
FROM dbo.vw_simpsons_transactions;
GO


TRUNCATE TABLE dbo.sum_simpsons_transactions;

INSERT INTO dbo.sum_simpsons_transactions (
    Member_ID,
    Name,
    Job_Title,
    Date,
    Description,
    Amount,
    Category
)
SELECT
    Member_ID,
    Name,
    Job_Title,
    Date,
    Description,
    Amount,
    Category
FROM dbo.vw_simpsons_transactions;
GO

-- Step 7: Create Stored Procedure for automation
IF OBJECT_ID('dbo.usp_load_simpsons_transactions', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_load_simpsons_transactions;
GO

CREATE PROCEDURE dbo.usp_load_simpsons_transactions
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE dbo.sum_simpsons_transactions;

    INSERT INTO dbo.sum_simpsons_transactions (
        Member_ID,
        Name,
        Job_Title,
        Date,
        Description,
        Amount,
        Category
    )
    SELECT
        Member_ID,
        Name,
        Job_Title,
        Date,
        Description,
        Amount,
        Category
    FROM dbo.vw_simpsons_transactions;
END;
GO


EXEC dbo.usp_load_simpsons_transactions;

SELECT TOP 10 *
FROM dbo.sum_simpsons_transactions;