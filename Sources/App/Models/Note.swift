//
//  Note.swift
//  App
//
//  Created by Huu Tai Vuong on 11/16/18.
//

import Foundation
import Vapor
import FluentSQLite

struct Note: SQLiteModel {
    var id: Int?
    var title: String
    var content: String
    var userId: User.ID
    var createdAt: Date?
    var updateAt: Date?
    
    var user: Parent<Note, User> {
        return parent(\.userId)
    }
    
    struct NoteForm: Content {
        var id: Int?
        var title: String
        var content: String 
    }
}

extension Note: Content { }
extension Note: Migration { }
