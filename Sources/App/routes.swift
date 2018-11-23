import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    try userRoute(router.grouped("user"))
    /// Order matters
    let authenticationMiddlewares: [Middleware] = [User.tokenAuthMiddleware(), TokenExpiredGuardMiddleware()]
    /// Routes that requires authenticated
    let authedRoutes = router.grouped(authenticationMiddlewares)
    
    try notesRoute(authedRoutes.grouped("notes"))
    try authRoute(authedRoutes.grouped("auth"))
    
    router.get("path") { request -> String in
        return DirectoryConfig.detect().workDir
    }
    
    router.get("ip") { request -> String in
        return request.http.url.absoluteString
    }
    
    router.get("image") { request -> Response in
        let params = try request.query.get(String.self, at: ["name"])
        let path = try request.query.get(String.self, at: ["path"])
        return request.redirect(to: "\(path)/\(params)")
    }
    
    router.get("env") { request -> String in
        let key = try request.query.get(String.self, at: ["key"])
        return ProcessInfo.processInfo.environment[key] ?? ""
    }
    
    router.get("env", "all") { request -> String in
        return ProcessInfo.processInfo.environment.reduce("", { (result, arg1) -> String in
            let (key, value) = arg1
            return result + "\(key):\(value)\n"
        })
    }
}

public func userRoute(_ router: Router) throws {
    let userController = UserController()
    router.post("register", use: userController.register)
    router.post("login", use: userController.login)
}

public func notesRoute(_ router: Router) throws {
    let notesController = NotesController()
    router.get(use: notesController.list)
    router.post("create", use: notesController.create)
    router.post("update",Int.parameter, use: notesController.update)
}

public func authRoute(_ router: Router) throws {
    let authController = AuthController()
    router.post("refresh", use: authController.refresh)
}
