const jwt = require('jsonwebtoken');

const serverConfig = require('../serverConfig.js');
const utility = require('../utility.js');

// middleware func declaration for token validation
module.exports = (request, response, next) => {
    // get the full request route
    const requestRoute = `${request.protocol}://${request.get('Host')}${request.originalUrl}`;
    utility.logger.info(`conducting token validation on ${requestRoute}`);
    // check request for token
    const accessToken =
        (request.body && request.body.accessToken) ||
        (request.query && request.query.accessToken) ||
        request.headers['x-access-token'];
    if (accessToken) { // if a token is found
        jwt.verify(accessToken, serverConfig.passphrase, (error, decodedToken) => {
            if (error) {
                return response.status(403).json(
                    utility.endpointErrorHandler(
                        request.method,
                        request.originalUrl,
                        `帳號使用權限發生錯誤: ${error.message}`)
                );
            }
            utility.logger.info('credential is valid...');
            next();
        });
    } else { // if there is no token, return an error
        return response.status(403).json(
            utility.endpointErrorHandler(
                request.method,
                request.originalUrl,
                '認證遺失，請重新登入')
        );
    }
};
