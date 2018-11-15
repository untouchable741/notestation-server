//
//  Token.swift
//  App
//
//  Created by Huu Tai Vuong on 11/15/18.
//

import Foundation
import Fluent
import FluentSQLite
import Authentication

struct Token: SQLiteModel {
    var id: Int?
    var token: String
    var userId: User.ID
    var expiry: Date
    
    init(token: String, userId: User.ID, expiry: Date) {
        self.token = token
        self.userId = userId
        self.expiry = expiry
    }
    
    var user: Parent<Token, User> {
        return parent(\.userId)
    }
}

extension Token: BearerAuthenticatable {
    static var tokenKey: WritableKeyPath<Token, String> {
        return \Token.token
    }
}

extension Token: Authentication.Token {
    typealias UserType = User
    typealias UserIDType = User.ID
    
    static var userIDKey: WritableKeyPath<Token, User.ID> {
        return \Token.userId
    }
}

extension Token: Migration { }
extension Token: Content { }
