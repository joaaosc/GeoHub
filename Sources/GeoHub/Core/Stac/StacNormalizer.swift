import Vapor
import CryptoKit

struct StacNormalizer {

    /// Gera um ID determinístico (reprodutível) a partir da fonte + query.
    /// Mantém o ID estável entre execuções usando SHA-256.
    static func datasetId(source: String, query: StacSearchRequest) -> String {
        let collectionsKey = query.collections.joined(separator: ",")
        let bboxKey = query.bbox.map { String($0) }.joined(separator: ",")

        let key =
            "\(source)|" +
            "\(collectionsKey)|" +
            "\(bboxKey)|" +
            "\(query.datetime ?? "")|" +
            "\(query.limit ?? 0)"

        let digest = SHA256.hash(data: Data(key.utf8))
        let hex = digest.map { String(format: "%02x", $0) }.joined()
        return "ds-\(hex.prefix(16))"
    }

    static func nowISO8601() -> String {
        ISO8601DateFormatter().string(from: Date())
    }

    /// Converte um STAC FeatureCollection (tipado minimamente) em um Dataset interno do GeoHub.
    static func normalize(
        datasetId: String,
        createdAt: String,
        source: String,
        query: StacSearchRequest,
        stac: StacFeatureCollection
    ) -> Dataset {

        let items: [DatasetItem] = stac.features.map { feature in
            let assets: [DatasetAsset] = (feature.assets ?? [:])
                .map { name, asset in
                    DatasetAsset(name: name, href: asset.href, type: asset.type)
                }
                .sorted { $0.name < $1.name }

            return DatasetItem(
                id: feature.id,
                datetime: feature.properties?.datetime,
                bbox: feature.bbox,
                assets: assets
            )
        }

        return Dataset(
            id: datasetId,
            createdAt: createdAt,
            source: source,
            query: query,
            items: items
        )
    }
}
