//
//  ContentView.swift
//  counter state
//
//  Created by yun on 2023/06/18.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var counter = Counter()
    
    var body: some View {
        VStack {
            Text("Count: \(counter.count)")
                .font(.largeTitle)
            
            Button("Increase") {
                counter.increase()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
