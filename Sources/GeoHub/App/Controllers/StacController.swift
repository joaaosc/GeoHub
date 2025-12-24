import Vapor

struct StacController {
    let client = StacClient()

    func search(_ req: Request) async throws -> Response {
        let query = try req.content.decode(StacSearchRequest.self)
        let buffer = try await client.search(req, query: query)

        var res = Response(status: .ok)
        res.headers.replaceOrAdd(name: .contentType, value: "application/json")
        res.body = .init(buffer: buffer)
        return res
    }
}
