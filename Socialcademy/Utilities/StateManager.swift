//
//  ErrorHandler.swift
//  Socialcademy
//
//  Created by Angelo Delgado on 7/2/23.
//

import Foundation

@MainActor
protocol StateManager: AnyObject {
    var error: Error? { get set }
    var isWorking: Bool { get set }
}

extension StateManager {
    nonisolated func withStateManagingTask(perform action: @escaping Action) {
        Task {
            await withStateManagement(perform: action)
        }
    }
    
    private func withStateManagement(perform action: @escaping Action) async {
        isWorking = true
        do {
            try await action()
        } catch {
            print("[\(Self.self)] Error: \(error)")
            self.error = error
        }
        isWorking = false
    }
}

extension StateManager {
    typealias Action = () async throws -> Void
    
    var isWorking: Bool {
        get { false }
        set {}
    }
    
    
}
