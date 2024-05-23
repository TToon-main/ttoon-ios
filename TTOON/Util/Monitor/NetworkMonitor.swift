//
//  NetworkMonitor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 4/18/24.
//

import Foundation
import Network

enum ConnectionType {
    case cellular
    case ethernet
    case unknown
    case wifi
}

final class NetworkMonitor {
    var isConnected: Bool = false
    var connectionType: ConnectionType = .unknown
    private let queue = DispatchQueue.global()
    private var monitor: NWPathMonitor
    static let shared = NetworkMonitor()
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            self.isConnected = path.status == .satisfied
            self.fetchConnectionType(path)
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    private func fetchConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi){
            connectionType = .wifi
        }else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        }else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        }else {
            connectionType = .unknown
        }
    }
}
