import Vapor

struct JsonStorage {
    let basePath: String

    init(basePath: String = "data") {
        self.basePath = basePath
    }

    func ensureDirectories() throws {
        try ensureDir("\(basePath)")
        try ensureDir("\(basePath)/raw")
        try ensureDir("\(basePath)/datasets")
    }

    func saveRawStac(datasetId: String, json: ByteBuffer) throws -> String {
        try ensureDirectories()
        let path = "\(basePath)/raw/\(datasetId).json"
        try writeByteBuffer(json, to: path)
        return path
    }

    func saveDataset(_ dataset: Dataset) throws -> String {
        try ensureDirectories()
        let path = "\(basePath)/datasets/\(dataset.id).json"
        let data = try JSONEncoder.pretty.encode(dataset)
        try data.write(to: URL(fileURLWithPath: path), options: .atomic)
        return path
    }

    func listDatasets() throws -> [Dataset] {
        try ensureDirectories()
        let dir = URL(fileURLWithPath: "\(basePath)/datasets")
        let files = try FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)
            .filter { $0.pathExtension.lowercased() == "json" }
            .sorted { $0.lastPathComponent < $1.lastPathComponent }

        return try files.map { url in
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(Dataset.self, from: data)
        }
    }

    func loadDataset(id: String) throws -> Dataset {
        try ensureDirectories()
        let path = "\(basePath)/datasets/\(id).json"
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        return try JSONDecoder().decode(Dataset.self, from: data)
    }

    // MARK: - Helpers

    private func ensureDir(_ path: String) throws {
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: path, isDirectory: &isDir) {
            if isDir.boolValue { return }
            throw Abort(.internalServerError, reason: "\(path) exists but is not a directory")
        }
        try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
    }

    private func writeByteBuffer(_ buffer: ByteBuffer, to path: String) throws {
        var copy = buffer
        let data = copy.readData(length: copy.readableBytes) ?? Data()
        try data.write(to: URL(fileURLWithPath: path), options: .atomic)
    }
}

extension JSONEncoder {
    static var pretty: JSONEncoder {
        let enc = JSONEncoder()
        enc.outputFormatting = [.prettyPrinted, .sortedKeys]
        return enc
    }
}
