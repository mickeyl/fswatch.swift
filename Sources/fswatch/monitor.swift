import Foundation
import libfswatch

private func callback(cevent: UnsafePointer<fsw_cevent>?, uint32: UInt32, data: UnsafeMutableRawPointer?) {
    guard let p_cevent = cevent else {
        return
    }
    let path = String(cString: p_cevent.pointee.path)
    Task { await Monitor.shared.handleEvent(forPath: path) }
}

public actor Monitor {

    public enum Error: FSW_STATUS, Swift.Error {

        case ok = 0
        case unknown = 1
        case sessionUnknown = 2
        case monitorAlreadyExists = 4
        case callbackNotSet = 8
        case pathsNotSet = 16
        case missingContext = 32
        case invalidPath = 64
        case invalidCallback = 128
        case invalidLatency = 256
        case invalidRegex = 512
        case monitorAlreadyRunning = 1024
        case unknownValue = 2048
        case invalidProperty = 4096
    }

    public typealias Completion = () -> ()

    private struct Watch {
        let path: String
        let then: Completion
    }

    private var watches: [String: Watch] = [:]
    public static var shared: Monitor = .init()

    private static var initialized: Bool = false

    private lazy var session: FSW_HANDLE = {
        if !Self.initialized {
            fsw_init_library()
            Self.initialized = true
        }
        let session = fsw_init_session(system_default_monitor_type)
        fsw_set_callback(session, callback, UnsafeMutableRawPointer(bitPattern: 0))
        return session!
    }()

    public func addPath(_ path: String, then: @escaping Completion) throws {
        let realpath = try self.realpath(path)
        try checked { realpath.withCString { fsw_add_path(self.session, $0) } }
        let watch = Watch(path: realpath, then: then)
        let startMonitor = self.watches.isEmpty
        self.watches[realpath] = watch
        guard startMonitor else { return }
        self.startMonitor()
    }
}

extension Monitor {

    private func startMonitor() {

        let thread = Thread {
            do {
                try self.checked { fsw_start_monitor(self.session) }
            } catch {
                print("Can't launch monitoring thread: \(error)")
            }
        }
        thread.qualityOfService = .background
        thread.name = "dev.cornucopia.fswatch.swift"
        thread.start()
    }

    fileprivate func handleEvent(forPath path: String) {
        guard let watch = self.watches[path] else { return }
        watch.then()
    }

    private func checked(function: () -> FSW_STATUS) throws {
        let status = function()
        guard status == 0 else {
            let error = Error(rawValue: status) ?? .unknown
            throw error
        }
    }

    private func realpath(_ path: String) throws -> String {

        guard let p = Foundation.realpath(path, nil) else { throw Error.invalidPath }
        return String(cString: p)
    }
}
