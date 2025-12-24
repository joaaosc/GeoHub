import Vapor

struct DatasetsController {
    private let storage = JsonStorage()

    func list(_ req: Request) async throws -> [Dataset] {
        try storage.listDatasets()
    }

    func get(_ req: Request) async throws -> Dataset {
        guard let id = req.parameters.get("id") else {
            throw Abort(.badRequest, reason: "Missing dataset id")
        }
        return try storage.loadDataset(id: id)
    }
}
