import ArgumentParser
import Foundation
import libfswatch_swift

@main
struct Watch: ParsableCommand {

    @Argument(help: "The path to watch.")
    var path: String

    mutating func run() throws {

        Task {
            do {
                try await Monitor.shared.addPath("/tmp/foo") {
                    print("path has changed!")
                }
            } catch {
                print("Error: \(error)")
            }
        }

        RunLoop.current.run()

    }
}