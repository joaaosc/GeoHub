import Vapor

func routes(_ app: Application) throws {
    let health = HealthController()
    app.get("health", use: health.health)
}
