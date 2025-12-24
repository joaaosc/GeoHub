import Vapor

struct StacClient {
    let baseURL: URI

    init(baseURL: String = "https://planetarycomputer.microsoft.com/api/stac/v1") {
        self.baseURL = URI(string: baseURL)
    }

    func search(_ req: Request, query: StacSearchRequest) async throws -> ByteBuffer {
        try query.validate()

        let body = StacSearchBody(
            collections: query.collections,
            bbox: query.bbox,
            datetime: query.datetime,
            limit: query.limit
        )

        let url = URI(string: "\(baseURL.string)/search")

        let resp = try await req.client.post(url) { clientReq in
            clientReq.headers.replaceOrAdd(name: .contentType, value: "application/json")
            try clientReq.content.encode(body)
        }

        guard resp.status == .ok else {
            let status = resp.status.code
            throw Abort(.badRequest, reason: "STAC search failed with HTTP \(status)")
        }

        return resp.body ?? ByteBuffer()
    }
}
