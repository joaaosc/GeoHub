import Vapor

enum JobStatus: String, Content {
    case pending
    case running
    case finished
    case failed
}

struct Job: Content {
    let id: String
    let type: String
    let datasetId: String?
    let status: JobStatus
    let createdAt: String
    let finishedAt: String?
}
