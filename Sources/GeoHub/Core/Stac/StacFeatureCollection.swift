import Vapor

struct StacFeatureCollection: Content {
    let type: String
    let features: [StacFeature]
}

struct StacFeature: Content {
    let id: String
    let bbox: [Double]?
    let properties: StacProperties?
    let assets: [String: StacAsset]?
}

struct StacProperties: Content {
    let datetime: String?
}

struct StacAsset: Content {
    let href: String
    let type: String?
}
