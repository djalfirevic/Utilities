import Foundation
import Network

class NetworkMonitor {
	
	// MARK: - Properties
	static let shared = NetworkMonitor()
	var monitor: NWPathMonitor?
	var isMonitoring = false
	var didStartMonitoringHandler: (() -> Void)?
	var didStopMonitoringHandler: (() -> Void)?
	var netStatusChangeHandler: (() -> Void)?
	var isConnected: Bool {
		guard let monitor = monitor else { return false }
		return monitor.currentPath.status == .satisfied
	}
	var interfaceType: NWInterface.InterfaceType? {
		guard let monitor = monitor else { return nil }
		
		return monitor.currentPath.availableInterfaces.filter {
			monitor.currentPath.usesInterfaceType($0.type) }.first?.type
	}
	var availableInterfacesTypes: [NWInterface.InterfaceType]? {
		guard let monitor = monitor else { return nil }
		return monitor.currentPath.availableInterfaces.map { $0.type }
	}
	var isExpensive: Bool {
		return monitor?.currentPath.isExpensive ?? false
	}
	
	// MARK: - Initializer
	private init() {}
	
	// MARK: - Deinitializer
	deinit {
		stopMonitoring()
	}
	
	// MARK: - Public API
	func startMonitoring() {
		guard !isMonitoring else { return }
		
		monitor = NWPathMonitor()
		let queue = DispatchQueue(label: "NetworkMonitor_Queue")
		monitor?.start(queue: queue)
		
		monitor?.pathUpdateHandler = { _ in
			self.netStatusChangeHandler?()
		}
		
		isMonitoring = true
		didStartMonitoringHandler?()
	}
	
	func stopMonitoring() {
		guard isMonitoring, let monitor = monitor else { return }
		
		monitor.cancel()
		self.monitor = nil
		isMonitoring = false
		didStopMonitoringHandler?()
	}
	
}
