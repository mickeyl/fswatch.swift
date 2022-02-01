import ArgumentParser
import Foundation
import fswatch

@main
struct Watch: ParsableCommand {

    @Argument(help: "The path to watch.")
    var path: String

    mutating func run() throws {

        let path = path
        Task {
            do {
                try await Monitor.shared.addPath(path) {
                    print("path \(path) has changed!")
                    Foundation.exit(0)
                }
            } catch {
                print("Error: \(error)")
                Foundation.exit(-1)
            }
        }

        RunLoop.current.run()

    }
}