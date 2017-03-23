SELECT
    a.id
    ,a.pOId
    ,CONVERT(CHAR(10),a.requestDate,126) AS 'requestDate'
    ,CONVERT(CHAR(10),a.receivedDate,126) AS 'receivedDate'
    ,CASE
        WHEN a.receivedDate IS NULL THEN CONVERT(CHAR(10),a.requestDate,126)
        ELSE CONVERT(CHAR(10),a.receivedDate,126)
        END AS 'workingDate'
    ,a.CUS_NO
    ,c.CUST_SNM
    ,c.CUST_NAME
    ,d.contractType
    ,a.PRD_NO
    ,c.PRDT_SNM
    ,a.typeId
    ,c.specification
    ,a.unitPrice
    ,c.unitPrice AS 'referencePrice'
    ,c.currency
    ,a.requestWeight
    ,c.qtyPerShipment
    ,a.supplierWeight
    ,a.actualWeight
    ,a.note
    ,a.created
    ,a.deprecated
    ,b.id AS 'purchaseOrder:id'
    ,b.revisionNumber AS 'purchaseOrder:revisionNumber'
    ,b.originalPOId AS 'purchaseOrder:originalPOId'
    ,b.pONumber AS 'purchaseOrder:pONumber'
    ,b.contractType AS 'purchaseOrder:contractType'
    ,CONVERT(CHAR(10),b.documentDate,126) AS 'purchaseOrder:documentDate'
    ,b.workingYear AS 'purchaseOrder:workingYear'
    ,b.workingMonth AS 'purchaseOrder:workingMonth'
    ,CONVERT(CHAR(10),b.startingDate,126) AS 'purchaseOrder:startingDate'
    ,CONVERT(CHAR(10),b.endDate,126) AS 'purchaseOrder:endDate'
    ,b.CUS_NO AS 'purchaseOrder:CUS_NO'
    ,b.customGross AS 'purchaseOrder:customGross'
    ,b.customTax AS 'purchaseOrder:customTax'
    ,b.customNet AS 'purchaseOrder:customNet'
    ,CONVERT(CHAR(10),b.confirmDate,126) AS 'purchaseOrder:confirmDate'
    ,CONVERT(CHAR(10),b.fulfillDate,126) AS 'purchaseOrder:fulfillDate'
    ,CONVERT(CHAR(10),b.finalizeDate,126) AS 'purchaseOrder:finalizeDate'
    ,b.created AS 'purchaseOrder:created'
    ,b.deprecated AS 'purchaseOrder:deprecated'
FROM rawMaterial.dbo.shipment a
    LEFT JOIN rawMaterial.dbo.purchaseOrder b ON a.pOId=b.id
    LEFT JOIN rawMaterial.dbo.rawMaterialSpecDetail c ON (a.CUS_NO=c.CUS_NO) AND (a.PRD_NO=c.PRD_NO) AND (a.typeId=c.typeId)
    LEFT JOIN rawMaterial.dbo.supplier d ON a.CUS_NO=d.CUS_NO
WHERE (
    (a.deprecated IS NULL) OR
    ((a.deprecated IS NOT NULL) AND (a.pOId IS NOT NULL) AND (b.deprecated IS NULL))
);
