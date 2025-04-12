//
//  KeyboardView.swift
//  List Photo
//
//  Created by KhuePM on 12/4/25.
//

import UIKit

class Debouncer {
    private var workItem: DispatchWorkItem?
    private let delay: TimeInterval

    init(delay: TimeInterval = 0.4) {
        self.delay = delay
    }

    func run(action: @escaping () -> Void) {
        workItem?.cancel()
        workItem = DispatchWorkItem(block: action)
        if let workItem = workItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
        }
    }
}
