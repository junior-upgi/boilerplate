const express = require('express');

const serverConfig = require('../../serverConfig.js');
const utility = require('../../utility.js');

const router = express.Router();

router.get('/utility/status', (request, response) => {
    return response.status(200).json({
        hostname: serverConfig.serverHostname,
        system: serverConfig.systemReference,
        status: 'online',
        timestamp: utility.currentDatetimeString
    });
});

module.exports = router;
