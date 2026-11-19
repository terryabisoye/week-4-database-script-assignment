-- Question: How can we return a simple "Hello World!" greeting through an 8-step T-SQL workflow?

-- Answer: 1. Test a simple SELECT statement returning 'Hello World!'.
-- 2. Wrap the query in a View (dbo.vw_hello_world).
-- 3. Create a physical summary table (dbo.sum_hello_world) from the View.
-- 4. Automate refreshing the summary table using a stored procedure (dbo.usp_load_hello_world).


SELECT 'Hello World!' AS Greeting;


IF OBJECT_ID('dbo.vw_hello_world', 'V') IS NOT NULL
    DROP VIEW dbo.vw_hello_world;
GO

CREATE VIEW dbo.vw_hello_world AS
SELECT 'Hello World!' AS Greeting;
GO


IF OBJECT_ID('dbo.sum_hello_world', 'U') IS NOT NULL
    DROP TABLE dbo.sum_hello_world;
GO


SELECT
    Greeting
INTO dbo.sum_hello_world
FROM dbo.vw_hello_world;
GO


TRUNCATE TABLE dbo.sum_hello_world;

INSERT INTO dbo.sum_hello_world (
    Greeting
)
SELECT
    Greeting
FROM dbo.vw_hello_world;
GO


IF OBJECT_ID('dbo.usp_load_hello_world', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_load_hello_world;
GO

CREATE PROCEDURE dbo.usp_load_hello_world
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE dbo.sum_hello_world;

    INSERT INTO dbo.sum_hello_world (
        Greeting
    )
    SELECT
        Greeting
    FROM dbo.vw_hello_world;
END;
GO


EXEC dbo.usp_load_hello_world;

SELECT
    Greeting
FROM dbo.sum_hello_world;
GO

