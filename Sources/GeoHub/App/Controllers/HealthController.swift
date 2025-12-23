import Vapor

struct HealthResponse: Content {
    let status: String
    let timestamp: String
}

struct HealthController {
    func health(_ req: Request) async -> HealthResponse {
        HealthResponse(
            status: "ok",
            timestamp: ISO8601DateFormatter().string(from: Date())
        )
    }
}
