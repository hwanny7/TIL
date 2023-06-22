//
//  ContentView.swift
//  client
//
//  Created by yun on 2023/06/22.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .house
    
    
    
    var body: some View {
        
        ZStack {
            VStack {
                TabView(selection: $selectedTab) {
                    ForEach(Tab.allCases, id: \.rawValue) { tab in
                        Text("\(tab.rawValue)")
                            .tag(tab)
                        // 여기서 tag가 무슨 역할 하는지 알아보기
                        // 실제 페이지랑 연결하기 switch 문으로?
                    }
                }
            }
            
            VStack {
                Spacer()
                BottomNavBar(selectedTab: $selectedTab)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
