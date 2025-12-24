import Vapor

public func configure(_ app: Application) throws {

    // Serve arquivos estáticos de /Public
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // Registrar rotas
    try routes(app)
}
