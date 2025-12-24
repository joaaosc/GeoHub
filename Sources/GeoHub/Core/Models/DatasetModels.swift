import Vapor

struct Dataset: Content {
    let id: String
    let createdAt: String         // ISO8601
    let source: String            // ex: "planetarycomputer"
    let query: StacSearchRequest
    let items: [DatasetItem]
}

struct DatasetItem: Content {
    let id: String
    let datetime: String?
    let bbox: [Double]?
    let assets: [DatasetAsset]
}

struct DatasetAsset: Content {
    let name: String
    let href: String
    let type: String?
}
