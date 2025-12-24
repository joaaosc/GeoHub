import Vapor

struct JobsController {

    private let storage = JobStorage()

    func create(_ req: Request) async throws -> Job {

        struct CreateJobRequest: Content {
            let type: String
            let datasetId: String?
        }

        let body = try req.content.decode(CreateJobRequest.self)

        let job = Job(
            id: UUID().uuidString,
            type: body.type,
            datasetId: body.datasetId,
            status: .pending,
            createdAt: ISO8601DateFormatter().string(from: Date()),
            finishedAt: nil
        )

        try storage.save(job)
        return job
    }

    func list(_ req: Request) async throws -> [Job] {
        try storage.list()
    }
}
