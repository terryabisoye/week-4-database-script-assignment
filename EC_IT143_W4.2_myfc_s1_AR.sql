-- Question: What are the names and monthly salaries of our soccer players by joining player details and fact data?


-- Answer: 
-- 1. Write an ad hoc JOIN query linking tblPlayerDim and tblPlayerFact on pl_id.
-- 2. Save the query as a reusable View.
-- 3. Create a physical summary table.
-- 4. Build a stored procedure to automate refreshing the table data.

-- Step 3: Ad hoc SQL query with a JOIN
SELECT TOP 10 
    p.pl_id,
    p.pl_name,
    f.mtd_salary
FROM tblPlayerDim p
JOIN tblPlayerFact f 
    ON p.pl_id = f.pl_id;

    

-- Your previous queries (Step 1, Step 2, Step 3, etc.) are up here...

GO  

-- Step 4: Create a reusable View
CREATE VIEW vw_myfc_player_salaries AS
SELECT 
    p.pl_id,
    p.pl_name,
    f.mtd_salary
FROM tblPlayerDim p
JOIN tblPlayerFact f 
    ON p.pl_id = f.pl_id;
GO



IF OBJECT_ID('dbo.sum_myfc_player_salaries', 'U') IS NOT NULL
    DROP TABLE dbo.sum_myfc_player_salaries;
GO

SELECT *
INTO dbo.sum_myfc_player_salaries
FROM vw_myfc_player_salaries;
GO


TRUNCATE TABLE dbo.sum_myfc_player_salaries;

INSERT INTO dbo.sum_myfc_player_salaries
SELECT * FROM vw_myfc_player_salaries;
GO

-- Step 7: Create Stored Procedure for automation
CREATE PROCEDURE usp_load_myfc_player_salaries
AS
BEGIN
    TRUNCATE TABLE dbo.sum_myfc_player_salaries;

    INSERT INTO dbo.sum_myfc_player_salaries
    SELECT * FROM vw_myfc_player_salaries;
END;
GO


EXEC usp_load_myfc_player_salaries;

SELECT TOP 5 * FROM dbo.sum_myfc_player_salaries;



