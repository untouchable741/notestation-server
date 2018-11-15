//
//  TokenExpiredGuardMiddleware.swift
//  App
//
//  Created by Huu Tai Vuong on 11/15/18.
//

import Foundation
import Vapor

final class TokenExpiredGuardMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        guard try request.requireAuthenticated(Token.self).expiry > Date() else {
            throw AuthError.tokenExpired
        }
        return try next.respond(to: request)
    }
}
