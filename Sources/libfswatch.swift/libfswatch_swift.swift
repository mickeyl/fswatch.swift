import libfswatch

func callback(cevent: UnsafePointer<fsw_cevent>?, uint32: UInt32, data: Optional<UnsafeMutableRawPointer>) {
    print("callback!")
}

enum Error: FSW_STATUS, Swift.Error {

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

public actor Monitor {

    public typealias Completion = () -> ()

    private struct Watch {
        let path: String
        let then: Completion
    }

    private var watches: [Watch] = []
    public static var shared: Monitor = .init()

    private static var initialized: Bool = false

    private lazy var session: FSW_HANDLE = {
        if !Self.initialized {
            fsw_init_library()
        }
        let session = fsw_init_session(system_default_monitor_type)
        fsw_set_callback(session, callback, UnsafeMutableRawPointer(bitPattern: 0))
        return session!
    }()


    private func checked(function: () -> FSW_STATUS) throws {
        let status = function()
        guard status == 0 else {
            let error = Error(rawValue: status) ?? .unknown
            throw error
        }
    }

    public func addPath(_ path: String, then: @escaping Completion) throws {

        try checked { path.withCString { fsw_add_path(self.session, $0) } }
        let watch = Watch(path: path, then: then)
        self.watches.append(watch)
        if self.watches.count == 1 {
            try checked{ fsw_start_monitor(self.session) }
        }
    }

}

