import Foundation

enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}

protocol NetworkCancellable {
    func cancel()
}

extension URLSessionTask: NetworkCancellable { }

protocol NetworkService {
    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    
    func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable?
}
// 요청을 수행하고, 완료 핸들러를 받는다.



protocol NetworkSessionManager {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> NetworkCancellable
}

protocol NetworkErrorLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}

// 네트워크 에러를 로깅하기 위한 프로토콜이다. 네트워크 요청과 에러를 로그에 출력하는 메서드를 제공한다.

// MARK: - Implementation

final class DefaultNetworkService {
    
    private let config: NetworkConfigurable
    private let sessionManager: NetworkSessionManager
    private let logger: NetworkErrorLogger
    
    init(
        config: NetworkConfigurable,
        sessionManager: NetworkSessionManager = DefaultNetworkSessionManager(),
        logger: NetworkErrorLogger = DefaultNetworkErrorLogger()
    ) {
        self.sessionManager = sessionManager
        self.config = config
        self.logger = logger
    }
    
    private func request(
        request: URLRequest,
        completion: @escaping CompletionHandler // Result<Data?, NetworkError>
    ) -> NetworkCancellable {
        
        let sessionDataTask = sessionManager.request(request) { data, response, requestError in
            
            if let requestError = requestError {
                var error: NetworkError
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                } else {
                    error = self.resolve(error: requestError)
                }
                
                self.logger.log(error: error)
                completion(.failure(error))
            } else {
                self.logger.log(responseData: data, response: response)
                completion(.success(data))
            }
        }
        
        // defaultNetworkSessionManger가 수행해서 return한 task를 클로저로 전달 받아서 수행한다.
        
        logger.log(request: request)

        return sessionDataTask
        
        // 비동기로 실행되기 때문에 취소 가능하다.
    }
    
    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
}

extension DefaultNetworkService: NetworkService {
    
    func request(
        endpoint: Requestable,
        completion: @escaping CompletionHandler
    ) -> NetworkCancellable? {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            return request(request: urlRequest, completion: completion)
        } catch {
            completion(.failure(.urlGeneration))
            return nil
        }
    }
}
// 외부에서 사용하기 쉽게 추상화된 인터페이스를 제공하기 위한 것이며, 첫 번째 Request를 호출한다.
// 코드를 분리함으로써 재사용성과 유연성을 높였다.
// request(request:completion:) => 실제로 네트워크 요청을 수행하는 로직을 담당 (내부에 숨겨져 있음)
// request(endpoint:completion:) => networkservice 프로토콜을 준수하여 외부에서 사용하기 쉬운 인터페이스를 제공


// MARK: - Default Network Session Manager
// Note: If authorization is needed NetworkSessionManager can be implemented by using,
// for example, Alamofire SessionManager with its RequestAdapter and RequestRetrier.
// And it can be injected into NetworkService instead of default one.

final class DefaultNetworkSessionManager: NetworkSessionManager {
    func request(
        _ request: URLRequest,
        completion: @escaping CompletionHandler // (data, response, requestError) networkService의 핸들러
    ) -> NetworkCancellable {
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
        return task
    }
}

// MARK: - Logger

final class DefaultNetworkErrorLogger: NetworkErrorLogger {
    init() { }

    func log(request: URLRequest) {
//        print("-------------")
//        print("request: \(request.url!)")
//        print("headers: \(request.allHTTPHeaderFields!)")
//        print("method: \(request.httpMethod!)")
//        if let httpBody = request.httpBody, let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
//            printIfDebug("body: \(String(describing: result))")
//        } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
//            printIfDebug("body: \(String(describing: resultString))")
//        }
    }

    func log(responseData data: Data?, response: URLResponse?) {
        guard let data = data else { return }
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//            printIfDebug("responseData: \(String(describing: dataDict))")
        }
    }

    func log(error: Error) {
//        printIfDebug("\(error)")
    }
}

// MARK: - NetworkError extension

extension NetworkError {
    var isNotFoundError: Bool { return hasStatusCode(404) }
    
    func hasStatusCode(_ codeError: Int) -> Bool {
        switch self {
        case let .error(code, _):
            return code == codeError
        default: return false
        }
    }
}

extension Dictionary where Key == String {
    func prettyPrint() -> String {
        var string: String = ""
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            if let nstr = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                string = nstr as String
            }
        }
        return string
    }
}

// 딕셔너리를 예쁘게 출력하기 위한 메서드

func printIfDebug(_ string: String) {
    #if DEBUG
//    print(string)
    #endif
}
