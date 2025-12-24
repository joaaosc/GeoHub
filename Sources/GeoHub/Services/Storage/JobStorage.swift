import Vapor

struct JobStorage {
    private let basePath = "data/jobs"

    private func ensureDir() throws {
        if !FileManager.default.fileExists(atPath: basePath) {
            try FileManager.default.createDirectory(
                atPath: basePath,
                withIntermediateDirectories: true
            )
        }
    }

    func save(_ job: Job) throws {
        try ensureDir()
        let path = "\(basePath)/\(job.id).json"
        let data = try JSONEncoder.pretty.encode(job)
        try data.write(to: URL(fileURLWithPath: path), options: .atomic)
    }

    func list() throws -> [Job] {
        try ensureDir()
        let files = try FileManager.default.contentsOfDirectory(atPath: basePath)
            .filter { $0.hasSuffix(".json") }

        return try files.map { name in
            let data = try Data(contentsOf: URL(fileURLWithPath: "\(basePath)/\(name)"))
            return try JSONDecoder().decode(Job.self, from: data)
        }
    }
}
