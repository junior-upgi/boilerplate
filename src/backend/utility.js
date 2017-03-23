/*
const cron = require('node-cron');
const fs = require('fs');
const moment = require('moment-timezone');
const os = require('os');
const httpRequest = require('request-promise');
const winston = require('winston');

const serverConfig = require('./serverConfig.js');
const telegram = require('./model/telegram.js');

// logging utility
// Create the log directory if it does not exist
if (!fs.existsSync(serverConfig.logDir)) {
    fs.mkdirSync(serverConfig.logDir);
}
const logger = new(winston.Logger)({
    transports: [
        // colorize the output to the console
        new(winston.transports.Console)({
            timestamp: currentDatetimeString(),
            colorize: true,
            level: 'debug'
        }),
        new(winston.transports.File)({
            filename: `${serverConfig.logDir}/results.log`,
            timestamp: currentDatetimeString(),
            level: serverConfig.development ? 'debug' : 'info'
        })
    ]
});

// status report utility
const statusReport = cron.schedule('0 0 8,22 * * *', () => {
    logger.info(`${serverConfig.systemReference} reporting mechanism triggered`);
    const issuedDatetime = moment(new Date()).format('YYYY-MM-DD HH:mm:ss');
    const message = `${issuedDatetime} ${serverConfig.systemReference} server reporting in from ${os.hostname()}`;
    httpRequest({
        method: 'post',
        uri: serverConfig.botAPIUrl + telegram.getBotToken('upgiITBot') + '/sendMessage',
        body: {
            chat_id: serverConfig.administrator,
            text: `${message}`,
            token: telegram.getBotToken('upgiITBot')
        },
        json: true
    }).then((response) => {
        logger.verbose(`${message}`);
        return logger.info(`${serverConfig.systemReference} reporting mechanism completed`);
    }).catch((error) => {
        alertSystemError('statusReport', error);
        return logger.error(`${serverConfig.systemReference} reporting mechanism failure ${error}`);
    });
}, false);

// telegram messaging utility
function alertSystemError(functionRef, message) {
    httpRequest({ // broadcast alert heading
        method: 'post',
        uri: serverConfig.botAPIUrl + telegram.getBotToken('upgiITBot') + '/sendMessage',
        body: {
            chat_id: serverConfig.administrator,
            text: `error encountered while executing [${serverConfig.systemReference}][${functionRef}] @ ${currentDatetimeString()}`,
            token: telegram.getBotToken('upgiITBot')
        },
        json: true
    }).then((response) => {
        return httpRequest({ // broadcast alert body message
            method: 'post',
            uri: serverConfig.botAPIUrl + telegram.getBotToken('upgiITBot') + '/sendMessage',
            form: {
                chat_id: serverConfig.administrator,
                text: `error message: ${message}`,
                token: telegram.getBotToken('upgiITBot')
            }
        });
    }).then((response) => {
        return logger.info(`${serverConfig.systemReference} alert sent`);
    }).catch((error) => {
        return logger.error(`${serverConfig.systemReference} failure: ${error}`);
    });
}

function sendMobileMessage(recipientIDList, messageList, botName) {
    recipientIDList.forEach((recipientID) => {
        messageList.forEach((message) => {
            httpRequest({
                method: 'post',
                uri: serverConfig.botAPIUrl + telegram.getBotToken(botName) + '/sendMessage',
                form: {
                    chat_id: recipientID,
                    text: message,
                    token: telegram.getBotToken(botName)
                }
            }).then((response) => {
                logger.info('message sent');
            }).catch((error) => {
                logger.error(`messaging failure: ${error}`);
            });
        });
    });
    return;
}

function endpointErrorHandler(method, originalUrl, errorMessage) {
    const errorString = `${method} ${originalUrl} route failure: ${errorMessage}`;
    logger.error(errorString);
    logger.info(alertSystemError(serverConfig.systemReference, errorString));
    return {
        errorMessage: errorString
    };
}

// date and time utility
function currentDatetimeString() {
    return moment.utc(new Date()).format('YYYY-MM-DD HH:mm:ss');
}

function firstOfMonthString(year, month) {
    return moment(new Date(year, month - 1, 1), 'YYYY-MM-DD HH:mm:ss').format('YYYY-MM-DD');
}

function todayDateString() {
    return moment(new Date(), 'YYYY-MM-DD HH:mm:ss').format('YYYY-MM-DD');
}

module.exports = {
    alertSystemError: alertSystemError,
    endpointErrorHandler: endpointErrorHandler,
    logger: logger,
    sendMobileMessage: sendMobileMessage,
    statusReport: statusReport,
    // date and time utility
    currentDatetimeString: currentDatetimeString,
    firstOfMonthString: firstOfMonthString,
    todayDateString: todayDateString
};
*/
