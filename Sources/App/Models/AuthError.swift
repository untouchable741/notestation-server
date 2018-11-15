//
//  AuthError.swift
//  App
//
//  Created by Huu Tai Vuong on 11/15/18.
//

import Foundation
import Vapor

enum AuthError: AbortError {
    case usernameExisted
    case tokenExpired
    
    var status: HTTPResponseStatus {
        switch self {
        case .usernameExisted: return .badRequest
        case .tokenExpired: return .unauthorized
        }
    }
    var reason: String {
        switch self {
        case .usernameExisted:
            return "Username already taken"
        case .tokenExpired:
            return "Token has been expired"
        }
    }
    
    var identifier: String {
        return String(describing: type(of: self))
    }
}
