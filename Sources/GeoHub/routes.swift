import Vapor

struct HealthResponse: Content {
    let status: String
    let timestamp: String
}

func routes(_ app: Application) throws {
    app.get("health") { req async -> HealthResponse in
        HealthResponse(
            status: "ok",
            timestamp: ISO8601DateFormatter().string(from: Date())
        )
    }
}
