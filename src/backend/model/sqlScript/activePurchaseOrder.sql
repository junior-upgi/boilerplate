SELECT
    a.id
    ,a.revisionNumber
    ,a.originalPOId
    ,a.pONumber
    ,a.contractType
    ,CONVERT(CHAR(10),a.documentDate,126) AS documentDate
    ,a.workingYear
    ,a.workingMonth
    ,CONVERT(CHAR(10),a.startingDate,126) AS startingDate
    ,CONVERT(CHAR(10),a.endDate,126) AS endDate
    ,a.CUS_NO
    ,c.CUS_NO AS 'suppliers:CUS_NO'
    ,c.NAME AS 'suppliers:NAME'
    ,c.SNM AS 'suppliers:SNM'
    ,c.contractType AS 'suppliers:contractType'
    ,c.BOS_NM AS 'suppliers:BOS_NM'
    ,c.CNT_MAN1 AS 'suppliers:CNT_MAN1'
    ,c.CNT_MAN2 AS 'suppliers:CNT_MAN2'
    ,c.TEL1 AS 'suppliers:TEL1'
    ,c.TEL2 AS 'suppliers:TEL2'
    ,c.FAX AS 'suppliers:FAX'
    ,c.taxRate AS 'suppliers:taxRate'
    ,c.currency AS 'suppliers:currency'
    ,a.customGross
    ,a.customTax
    ,a.customNet
    ,CONVERT(CHAR(10),a.confirmDate,126) AS confirmDate
    ,CONVERT(CHAR(10),a.fulfillDate,126) AS fulfillDate
    ,CONVERT(CHAR(10),a.finalizeDate,126) AS finalizeDate
    ,a.created
    ,a.deprecated
    ,b.id AS 'shipments:id'
    ,b.pOId AS 'shipments:pOId'
    ,CONVERT(CHAR(10),b.requestDate,126) AS 'shipments:requestDate'
    ,CONVERT(CHAR(10),b.receivedDate,126) AS 'shipments:receivedDate'
    ,CASE
        WHEN b.receivedDate IS NULL THEN CONVERT(CHAR(10),b.requestDate,126)
        ELSE CONVERT(CHAR(10),b.receivedDate,126)
        END AS 'shipments:workingDate'
    ,b.CUS_NO AS 'shipments:CUS_NO'
    ,c.SNM AS 'shipments:CUST_SNM'
    ,b.PRD_NO AS 'shipments:PRD_NO'
    ,d.PRDT_SNM AS 'shipments:PRDT_SNM'
    ,b.typeId AS 'shipments:typeId'
    ,d.specification AS 'shipments:specification'
    ,CASE
        WHEN b.unitPrice IS NULL THEN d.unitPrice
        ELSE b.unitPrice
        END AS 'shipments:unitPrice'
    ,d.UT AS 'shipments:UT'
    ,d.currency AS 'shipments:currency'
    ,b.requestWeight AS 'shipments:requestWeight'
    ,b.supplierWeight AS 'shipments:supplierWeight'
    ,b.actualWeight AS 'shipments:actualWeight'
    ,b.note AS 'shipments:note'
    ,b.created AS 'shipments:created'
    ,b.deprecated AS 'shipments:deprecated'
    ,e.CUS_NO AS 'pONotices:CUS_NO'
    ,e.lineNumber AS 'pONotices:lineNumber'
    ,e.string AS 'pONotices:string'
FROM rawMaterial.dbo.purchaseOrder a
    LEFT JOIN rawMaterial.dbo.shipment b ON a.id=b.pOId
    LEFT JOIN rawMaterial.dbo.supplier c ON a.CUS_NO=c.CUS_NO
    LEFT JOIN rawMaterial.dbo.rawMaterialSpecDetail d ON (b.CUS_NO=d.CUS_NO) AND (b.PRD_NO=d.PRD_NO) AND (b.typeId=d.typeId)
    LEFT JOIN rawMaterial.dbo.pONotice e ON a.CUS_NO=e.CUS_NO
WHERE a.deprecated IS NULL;
