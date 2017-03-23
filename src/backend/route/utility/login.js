const bodyParser = require('body-parser');
const express = require('express');
const jwt = require('jsonwebtoken');
const ldap = require('ldapjs');

const serverConfig = require('../../serverConfig.js');
const utility = require('../../utility.js');
const errorHandler = utility.endpointErrorHandler;

const router = express.Router();
router.use(bodyParser.json());

router.post('/login', (request, response) => {
    const loginId = request.body.loginId;
    const method = request.method;
    const url = request.originalUrl;
    const ldapClient = ldap.createClient({ url: serverConfig.ldapServerUrl });
    ldapClient.bind(`uid=${loginId},ou=user,dc=upgi,dc=ddns,dc=net`, request.body.password, (error) => {
        if (error) {
            return response.status(403)
                .json(errorHandler(method, url, `${loginId} LDAP validation failure: ${error.lde_message}`));
        }
        ldapClient.unbind((error) => {
            if (error) {
                return response.status(403)
                    .json(errorHandler(method, url, `${loginId} LDAP server separation failure: ${error.lde_message}`));
            }
            utility.logger.info(`${loginId} account info validated, checking access rights`);
            // continue to check if user has rights to access the website of the system selected
            const knex = require('knex')(serverConfig.mssqlConfig);
            knex.select('*')
                .from('rawMaterial.dbo.privilegeDetail').debug(false)
                .where({ SAL_NO: loginId })
                .then((resultset) => {
                    if (resultset.length === 0) {
                        return response.status(403)
                            .json(errorHandler(method, url, `${loginId} 此帳號尚未設定原料採購進貨系統使用權限`));
                    } else {
                        utility.logger.info(`${loginId} ${serverConfig.systemReference} access privilege validated`);
                        const payload = resultset[0];
                        payload.loginId = loginId;
                        const token = jwt.sign(payload, serverConfig.passphrase, { expiresIn: 7200 });
                        utility.logger.info(`${loginId} login procedure completed`);
                        return response.status(200)
                            .json({ token: token });
                    }
                })
                .catch((error) => {
                    return response.status(500)
                        .json(errorHandler(method, url, `${loginId} 帳號權限資料讀取失敗: ${error}`));
                })
                .finally(() => {
                    knex.destroy();
                });
        });
    });
});

module.exports = router;
