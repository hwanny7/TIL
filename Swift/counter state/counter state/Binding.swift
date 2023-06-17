//
//  Binding.swift
//  counter state
//
//  Created by yun on 2023/06/18.
//

import SwiftUI

class Counter: ObservableObject {
    @Published var count = 0
    
    func increase () {
        count += 1
    }
    
}
