SELECT
    a.SAL_NO
	,a.type
	,a.role
	,b.NAME
	,b.DEP
	,d.NAME AS DEPT_NAME
	,b.POS
	,b.TEL2 AS mobileNumber
	,b.E_MAIL
	,c.DSC_REM AS telegramId
	,e.username
	,e.first_name
	,e.last_name
    ,CASE
        WHEN a.type = 'employee' THEN '+886 (0)6 653-6281'
        ELSE NULL
        END AS compPhone
    ,CASE
        WHEN a.SAL_NO = '05060001' THEN '#381'
        WHEN a.SAL_NO = '09100001' THEN '#173' -- 窯爐 林柏志
        WHEN a.SAL_NO = '10120001' THEN '#173' -- 窯爐 張高榮 課長
        WHEN a.SAL_NO = '95070003' THEN '#166' -- 採購 陳連虹貞
        WHEN a.SAL_NO = '17020004' THEN '#343' -- 採購 洪綿
        WHEN a.SAL_NO = '06070004' THEN '#163' -- 採購 陳逸樺 課長
        ELSE NULL
        END AS compPhoneExt
FROM rawMaterial.dbo.privilege a
    LEFT JOIN DB_U105.dbo.SALM b ON a.SAL_NO=b.SAL_NO
    LEFT JOIN DB_U105.dbo.SALM_DSC c ON a.SAL_NO=c.SAL_NO AND c.DSC_NO='telegramId'
    LEFT JOIN DB_U105.dbo.DEPT d ON b.DEP=d.DEP
    LEFT JOIN telegram.dbo.[user] e ON a.SAL_NO=e.SAL_NO AND CAST(c.DSC_REM AS INT)=e.id;
