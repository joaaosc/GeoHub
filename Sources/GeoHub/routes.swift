import Vapor

func routes(_ app: Application) throws {
    let health = HealthController()
    app.get("health", use: health.health)

    let stac = StacController()
    app.post("stac", "search", use: stac.search)
}
