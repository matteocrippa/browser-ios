/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import WebKit
import GCDWebServers

/// Handles requests to /about/sessionrestore to restore session history.
struct SessionRestoreHandler {
    static func register(_ webServer: WebServer) {
        // Register the handler that accepts /about/sessionrestore?history=...&currentpage=... requests.
        webServer.registerHandlerForMethod("GET", module: "about", resource: "sessionrestore") { request in
            if let request = request, !webServer.isRequestAuthenticated(request) { 
                return GCDWebServerResponse(statusCode: 401)
            }
            
            if let sessionRestorePath = Bundle.main.path(forResource: "SessionRestore", ofType: "html") {
                do {
                    let sessionRestoreString = try String(contentsOfFile: sessionRestorePath)
                    return GCDWebServerDataResponse(html: sessionRestoreString)
                } catch _ {}
            }

            return GCDWebServerResponse(statusCode: 404)
        }
    }
}
