import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws -> Response in
    let indexPath = req.application.directory.publicDirectory + "index.html"
    return req.fileio.streamFile(at: indexPath)
    }

    let health = HealthController()
    app.get("health", use: health.health)

    let stac = StacController()
    app.post("stac", "search", use: stac.search)

    let datasets = DatasetsController()
    app.get("datasets", use: datasets.list)
    app.get("datasets", ":id", use: datasets.get)

    let jobs = JobsController()
    app.post("jobs", use: jobs.create)
    app.get("jobs", use: jobs.list)
}
