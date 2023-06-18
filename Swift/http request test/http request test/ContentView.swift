//
//  ContentView.swift
//  http request test
//
//  Created by yun on 2023/06/18.
//

import SwiftUI

struct DogImage: Hashable, Codable {
    let message: String
    let status: String
}

class ViewModel: ObservableObject {
    @Published var dogImage: UIImage?
    
    func fetchData() {
        guard let url = URL(string: "https://dog.ceo/api/breeds/image/random") else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let dogImage = try JSONDecoder().decode(DogImage.self, from: data)
                guard let imageUrl = URL(string: dogImage.message) else { return }
                
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: imageUrl) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.dogImage = image
                                print("바꿨는데?")
                            }
                        }
                    }
                }
                
                
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            
        }
        task.resume()
    }
    
}


struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    
    var body: some View {
        VStack {
            if self.viewModel.dogImage != nil {
                Image(uiImage: self.viewModel.dogImage!)
            } else {
                Text("사진을 불러오는 중입니다.")
                    .multilineTextAlignment(.center)
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
