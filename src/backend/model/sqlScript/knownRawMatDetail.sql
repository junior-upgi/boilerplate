SELECT
	a.PRD_NO
	,b.SNM
	,b.UT
FROM rawMaterial.dbo.knownRawMatId a
	INNER JOIN DB_U105.dbo.PRDT b ON a.PRD_NO=b.PRD_NO;
