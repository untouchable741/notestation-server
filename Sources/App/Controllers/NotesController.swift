//
//  NotesController.swift
//  App
//
//  Created by Huu Tai Vuong on 11/15/18.
//

import Foundation
import Vapor
import Fluent

final class NotesController {
    func list(_ req: Request) throws -> String {
        let user = try req.requireAuthenticated(User.self)
        return "You're viewing notes of \(user.username)"
    }
}
