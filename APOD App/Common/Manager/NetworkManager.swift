//
//  NetworkManager.swift
//  APOD App
//
//  Created by Mohit Vegad on 28/10/2025.
//

import Network


final class NetworkManager {

    static let shared = NetworkManager()  // Singleton
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    private(set) var isConnected: Bool = true

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = (path.status == .satisfied)
            if path.status == .satisfied {
                print("✅ Internet connection is available")
            } else {
                print("⚠️ Internet connection seems to be offline")
            }
        }
        monitor.start(queue: queue)
    }
}
