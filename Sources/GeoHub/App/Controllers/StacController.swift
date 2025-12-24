import Vapor

struct StacController {
    private let client = StacClient()
    private let storage = JsonStorage()
    private let source = "planetarycomputer"

    func search(_ req: Request) async throws -> Dataset {
        let query = try req.content.decode(StacSearchRequest.self)

        // 1) Busca STAC (raw JSON)
        let raw = try await client.search(req, query: query)

        // 2) Gera ID determinístico + salva raw
        let datasetId = StacNormalizer.datasetId(source: source, query: query)
        try storage.saveRawStac(datasetId: datasetId, json: raw)

        // 3) Decodifica mínimo do STAC para normalizar
        var copy = raw
        let rawData = copy.readData(length: copy.readableBytes) ?? Data()
        let stac = try JSONDecoder().decode(StacFeatureCollection.self, from: rawData)

        // 4) Normaliza e salva Dataset
        let dataset = StacNormalizer.normalize(
            datasetId: datasetId,
            createdAt: StacNormalizer.nowISO8601(),
            source: source,
            query: query,
            stac: stac
        )
        try storage.saveDataset(dataset)

        // 5) Retorna Dataset normalizado
        return dataset
    }
}
