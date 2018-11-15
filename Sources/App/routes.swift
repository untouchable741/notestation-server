import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    try userRoute(router.grouped("user"))
    
    /// Order matters
    let authenticationMiddlewares: [Middleware] = [User.tokenAuthMiddleware(), TokenExpiredGuardMiddleware()]
    let authedRoutes = router.grouped(authenticationMiddlewares)
    try notesRoute(authedRoutes.grouped("notes"))
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

