import Foundation

protocol NetworkConfigurable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
    // language, api_key
}

struct ApiDataNetworkConfig: NetworkConfigurable {
    let baseURL: URL
    let headers: [String: String]
    let queryParameters: [String: String]
    
     init(
        baseURL: URL,
        headers: [String: String] = [:],
        queryParameters: [String: String] = [:]
     ) {
        self.baseURL = baseURL
        self.headers = headers
        self.queryParameters = queryParameters
    }
    
    // headers와 queryParameters가 없는 경우에는 기본값으로
    // header와 query는 딕셔너리 형태로
}
