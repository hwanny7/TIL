import Foundation

enum HTTPMethodType: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

enum BodyEncoding {
    case jsonSerializationData
    case stringEncodingAscii
}

// Body Data 인코딩 방식
// 근데 필요 없어 보임



protocol Requestable {
    var path: String { get }
    var isFullPath: Bool { get }
    // baseURL과 합쳐야 하는지
    var method: HTTPMethodType { get }
    
    var headerParameters: [String: String] { get }
    
    var queryParametersEncodable: Encodable? { get }
    var queryParameters: [String: Any] { get }
    // Encodable 객체가 아닐 때 대체할 파라미터
    
    var bodyParametersEncodable: Encodable? { get }
    var bodyParameters: [String: Any] { get }
    
    var bodyEncoding: BodyEncoding { get }
    
    func urlRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest
    // 프로토콜에는 사용자에게 필요한 기능만 요구한다. url 함수를 포함하지 않는 이유도 여기에 있다.
}

// Url 요청 객체를 생성하는 메소드

// Encodable한 parameter와 아닌 parameter

//struct User: Encodable {
//    let name: String
//    let age: Int
//}
//
//let user = User(name: "John Doe", age: 30)
//let encodableParameters: Encodable = user
//
//let simpleParameters: [String: Any] = [
//    "name": "John Doe",
//    "age": 30
//]


extension Requestable {
    
    // baseURL과 query를 합쳐서 url를 만든다.
    func url(with config: NetworkConfigurable) throws -> URL {

        let baseURL = config.baseURL.absoluteString.last != "/"
        ? config.baseURL.absoluteString + "/"
        : config.baseURL.absoluteString
        
        // baseURL만 잘 설정하면 이 코드도 필요 없어 보임
        
        let endpoint = isFullPath ? path : baseURL.appending(path)
        
        guard var urlComponents = URLComponents(
            string: endpoint
        ) else { throw RequestGenerationError.components }
        var urlQueryItems = [URLQueryItem]()

        let queryParameters = try queryParametersEncodable?.toDictionary() ?? self.queryParameters
        // Encodable 타입의 쿼리를 딕셔너리 형태로 변환한다.
        
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        config.queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        // 이건 필요없어 보이는데
        
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        
        guard let url = urlComponents.url else { throw RequestGenerationError.components }
        return url
    }
    
    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
        
        let url = try self.url(with: config)
        // 일단 url을 만든다.
        var urlRequest = URLRequest(url: url)
        
        var allHeaders: [String: String] = config.headers
        headerParameters.forEach { allHeaders.updateValue($1, forKey: $0) }
        // config header와 network header를 합친다.

        let bodyParameters = try bodyParametersEncodable?.toDictionary() ?? self.bodyParameters
        if !bodyParameters.isEmpty {
            urlRequest.httpBody = encodeBody(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding)
        }
        // jsonSerialization bodyEncoding 방식으로 딕셔너리를 인코딩해서 사용한다.
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        return urlRequest
    }
    
    private func encodeBody(bodyParameters: [String: Any], bodyEncoding: BodyEncoding) -> Data? {
        switch bodyEncoding {
        case .jsonSerializationData:
            return try? JSONSerialization.data(withJSONObject: bodyParameters)
        case .stringEncodingAscii:
            return bodyParameters.queryString.data(
                using: String.Encoding.ascii,
                allowLossyConversion: true
            )
        }
    }
}

protocol ResponseRequestable: Requestable {
    associatedtype Response
    
    var responseDecoder: ResponseDecoder { get }
}


// extension 으로 프로토콜 func 추가 구현


class Endpoint<R>: ResponseRequestable {
    // 연관타입은 json을 디코딩할 때 쓰일 구조체 ResponseDTO를 말한다.
    
    typealias Response = R
    
    let path: String
    let isFullPath: Bool
    let method: HTTPMethodType
    let headerParameters: [String: String]
    let queryParametersEncodable: Encodable?
    let queryParameters: [String: Any]
    let bodyParametersEncodable: Encodable?
    let bodyParameters: [String: Any]
    let bodyEncoding: BodyEncoding
    let responseDecoder: ResponseDecoder
    
    init(path: String,
         isFullPath: Bool = false,
         method: HTTPMethodType,
         headerParameters: [String: String] = [:],
         queryParametersEncodable: Encodable? = nil,
         queryParameters: [String: Any] = [:],
         bodyParametersEncodable: Encodable? = nil,
         bodyParameters: [String: Any] = [:],
         bodyEncoding: BodyEncoding = .jsonSerializationData,
         responseDecoder: ResponseDecoder = JSONResponseDecoder()) {
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
        self.headerParameters = headerParameters
        self.queryParametersEncodable = queryParametersEncodable
        self.queryParameters = queryParameters
        self.bodyParametersEncodable = bodyParametersEncodable
        self.bodyParameters = bodyParameters
        self.bodyEncoding = bodyEncoding
        self.responseDecoder = responseDecoder
    }
}



enum RequestGenerationError: Error {
    case components
}
// Url components 생성할 때 오류


private extension Dictionary {
    var queryString: String {
        return self.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
    }
}
// 아스키 코드일 때 필요

private extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String : Any]
    }
    
    // Encodable한 DTO -> json 인코딩 -> 딕셔너리
}
