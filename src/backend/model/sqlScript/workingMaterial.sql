SELECT
    workingYear
	,workingMonth
	,CUS_NO
	,CUST_SNM
	,PRD_NO
	,PRDT_SNM
FROM rawMaterial.dbo.shipmentOverview
GROUP BY CUS_NO,CUST_SNM,PRD_NO,PRDT_SNM,workingYear,workingMonth;
