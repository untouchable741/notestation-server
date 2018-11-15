//
//  UserController.swift
//  App
//
//  Created by Huu Tai Vuong on 11/15/18.
//

import Foundation
import Vapor
import FluentSQLite
import Crypto
import Fluent
import Random

class UserController {
    func register(_ req: Request) throws -> Future<User.Public> {
        return try req.content.decode(User.self).flatMap { user in
            //Check if username already existed
            return User.query(on: req).filter(\.username == user.username).first().flatMap { existingUser in
                guard existingUser == nil else {
                    throw AuthError.usernameExisted
                }
                let hasher = BCryptDigest()
                let hashedPassword = try hasher.hash(user.password)
                let newUser = User(id: nil, username: user.username, password: hashedPassword, createdAt: Date())
                return newUser.save(on: req).map { return $0.public }
            }
        }
    }
    
    func login(_ req: Request) throws -> Future<Token> {
        return try req.content.decode(User.self).flatMap { user in
            return User.query(on: req).filter(\.username == user.username).first().flatMap {
                existingUser in
                
                //Delete expired tokens
                let expiredTokens = Token.query(on: req).filter(\Token.expiry < Date())
                _ = expiredTokens.count().flatMap { count -> EventLoopFuture<Void> in
                    print("Number of expired token \(count)")
                    return expiredTokens.delete()
                }
                
                guard let existingUser = existingUser else {
                    throw Abort(.badRequest)
                }
                
                let verifier = BCryptDigest()
                if try verifier.verify(user.password, created: existingUser.password) {
                    return try existingUser.authTokens.query(on: req).first().flatMap { token in
                        if let token = token, token.expiry.timeIntervalSince(Date()) > 0 {
                            return Future.map(on: req) { token }
                        } else {
                            let tokenString = try URandom().generateData(count: 32).base32EncodedString()
                            let token = try Token(token: tokenString, userId: existingUser.requireID(), expiry: Date().addingTimeInterval(86400))
                            return token.save(on: req)
                        }
                    }
                } else {
                    throw Abort(.unauthorized)
                }
            }
        }
    }
}
