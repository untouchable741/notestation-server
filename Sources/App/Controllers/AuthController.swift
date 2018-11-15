//
//  AuthController.swift
//  App
//
//  Created by Huu Tai Vuong on 11/16/18.
//

import Foundation
import Vapor
import FluentSQLite
import Random

final class AuthController {
    func refresh(_ req: Request) throws -> Future<Token> {
        let token = try req.requireAuthenticated(Token.self)
        let tokenString = try URandom().generateData(count: 32).base32EncodedString()
        return Token.query(on: req).filter(\.userId == token.user.parentID).delete().flatMap {
            return Token(token: tokenString, userId: token.userId, expiry: Date().addingTimeInterval(86400)).save(on: req)
        }
    }
}
