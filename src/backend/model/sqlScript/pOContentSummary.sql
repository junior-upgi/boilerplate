-- 將兩個 SUBQUERY 結果結合集結，再帶入各欄位代表之名稱
SELECT
    a.pOId
	,a.CUS_NO
	,c.CUST_SNM
	,c.CUST_NAME
	,a.PRD_NO
	,c.PRDT_SNM
	,a.typeId
	,c.specification
	,a.requestShipmentCount
	,a.totalRequestedWeight
	,ISNULL(b.pendingShipmentCount,0) AS pendingShipmentCount
	,a.requestShipmentCount-ISNULL(b.pendingShipmentCount,0) AS receivedShipmentCount
	,a.totalReceivedWeight
    ,c.unitPrice
    ,c.currency
    ,c.UT
FROM (
	-- 將所有未失效並已下單預約記錄以訂單號與貨品分類集結後，統計預約車次總計、預約總重以及已到貨量總計
	SELECT c.pOId ,c.CUS_NO ,c.PRD_NO ,c.typeId
		,COUNT(*) AS requestShipmentCount
		,SUM(c.requestWeight) AS totalRequestedWeight
		,SUM(c.receivedWeight) AS totalReceivedWeight
    FROM (
		-- 由所有未失效並已下單預約記錄，列舉訂單號、貨品編號類別以及要求進貨量與收貨量
		SELECT a.pOId ,a.CUS_NO ,a.PRD_NO ,a.typeId ,a.requestWeight
			,CASE
				-- 若進貨重量已填，取較大者之重量。廠商/地磅秤重皆未填則為0
				WHEN ((a.supplierWeight IS NULL) AND (a.actualWeight IS NULL)) THEN 0 -- 預防兩者皆未填時，帶null值可能產生未預防之錯誤
				WHEN a.actualWeight<=a.supplierWeight THEN a.actualWeight
				ELSE a.supplierWeight
				END AS receivedWeight
        FROM rawMaterial.dbo.shipment a
            LEFT JOIN rawMaterial.dbo.purchaseOrder b ON a.pOId=b.id
        WHERE
			a.deprecated IS NULL AND -- 進貨預約未取消
            a.pOId IS NOT NULL AND -- 進貨預約已下單
            b.deprecated IS NULL) AS c
    -- 訂單未失效
    GROUP BY c.pOId, c.CUS_NO, c.PRD_NO, c.typeId) a
    LEFT JOIN (
	-- 由所有未失效、未進貨並已經下單的預約記錄以訂單號與貨品分類集結，列舉尚未到貨車次總計
	SELECT
        a.pOId
		,a.CUS_NO
		,a.PRD_NO
		,a.typeId
		,COUNT(*) AS pendingShipmentCount
    FROM rawMaterial.dbo.shipment a
        LEFT JOIN rawMaterial.dbo.purchaseOrder b ON a.pOId=b.id
    WHERE
		a.deprecated IS NULL AND -- 未取消進貨預約
        a.pOId IS NOT NULL AND -- 已下單
        b.deprecated IS NULL AND -- 訂單未失效
        a.receivedDate IS NULL
    -- 尚未進貨
    GROUP BY a.pOId, a.CUS_NO, a.PRD_NO, a.typeId) b ON (a.pOId=b.pOId) AND (a.CUS_NO=b.CUS_NO) AND (a.PRD_NO=b.PRD_NO) AND (a.typeId=b.typeId)
    LEFT JOIN rawMaterial.dbo.rawMaterialSpecDetail AS c ON (a.CUS_NO=c.CUS_NO) AND (a.PRD_NO=c.PRD_NO) AND (a.typeId=c.typeId);
