SELECT
	a.PRD_NO
	,c.SNM AS PRDT_SNM
	,a.typeId
    ,b.UT
	,a.unitPrice
    ,a.currency
	,a.CUS_NO
	,d.SNM AS CUST_SNM
	,d.NAME AS CUST_NAME
	,a.specification
    ,a.qtyPerShipment
	,a.sequentialIndex
FROM rawMaterial.dbo.rawMaterialSpec a
    INNER JOIN rawMaterial.dbo.knownRawMatDetail b ON a.PRD_NO=b.PRD_NO
	INNER JOIN DB_U105.dbo.PRDT c ON a.PRD_NO=c.PRD_NO
	INNER JOIN rawMaterial.dbo.CUST d ON a.CUS_NO=d.CUS_NO
WHERE a.display=1;
