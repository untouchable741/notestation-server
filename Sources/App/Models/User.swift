//
//  User.swift
//  App
//
//  Created by Huu Tai Vuong on 11/15/18.
//

import Vapor
import FluentSQLite
import Foundation
import Authentication

struct User: Content, SQLiteModel, Migration {
    var id: Int?
    var username: String
    var password: String
    var createdAt: Date? = Date()
    
    var `public`: Public {
        return Public(id: id, username: username, createdAt: createdAt)
    }
    
    struct Public: Content {
        var id: Int?
        var username: String
        var createdAt: Date?
    }
    
    var notes: Children<User, Note> {
        return children(\.userId)
    }
}

extension User: TokenAuthenticatable {
    typealias TokenType = Token
}
