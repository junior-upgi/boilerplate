SELECT
    a.CUS_NO
	,a.NAME
	,a.SNM
    ,a.contractType
	,b.BOS_NM
	,b.CNT_MAN1
	,b.CNT_MAN2
	,b.TEL1
	,b.TEL2
	,b.FAX
    ,a.taxRate
    ,a.currency
FROM rawMaterial.dbo.CUST a
    INNER JOIN DB_U105.dbo.CUST b ON a.CUS_NO=b.CUS_NO;
