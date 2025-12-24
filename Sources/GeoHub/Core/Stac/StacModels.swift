import Vapor

/// Request que a API recebe
struct StacSearchRequest: Content {
    let collections: [String]
    let bbox: [Double]          // [minLon, minLat, maxLon, maxLat]
    let datetime: String?       // "YYYY-MM-DD/YYYY-MM-DD"
    let limit: Int?

    func validate() throws {
        guard !collections.isEmpty else {
            throw Abort(.badRequest, reason: "collections must not be empty")
        }
        guard bbox.count == 4 else {
            throw Abort(.badRequest, reason: "bbox must have exactly 4 numbers: [minLon, minLat, maxLon, maxLat]")
        }
        if let limit, limit <= 0 {
            throw Abort(.badRequest, reason: "limit must be > 0")
        }
    }
}

/// Body que o endpoint STAC /search espera (padrão STAC API).
struct StacSearchBody: Content {
    let collections: [String]
    let bbox: [Double]
    let datetime: String?
    let limit: Int?
}
