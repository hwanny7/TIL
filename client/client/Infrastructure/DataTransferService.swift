import Foundation

enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
}

protocol DataTransferDispatchQueue {
    func asyncExecute(work: @escaping () -> Void)
}

extension DispatchQueue: DataTransferDispatchQueue {
    func asyncExecute(work: @escaping () -> Void) {
        async(group: nil, execute: work)
    }
}

// extension으로 실제 함수 구현
// DispatchQueue의 async함수를 직접 사용할 수도 있었는데 왜?




// T 는 Type의 약자로 임의의 타입을 나타낸다.
// E는 Element의 약자로 컬렉션의 요소를 나타낸다.

protocol DataTransferService {
    typealias CompletionHandler<T> = (Result<T, DataTransferError>) -> Void
    
    @discardableResult
    func request<T: Decodable, E: ResponseRequestable>(
        with endpoint: E,
        on queue: DataTransferDispatchQueue,
        completion: @escaping CompletionHandler<T>
    ) -> NetworkCancellable? where E.Response == T
    // 응답 형식과 요청 형식이 일치해야 한다.
    
    @discardableResult
    func request<T: Decodable, E: ResponseRequestable>(
        with endpoint: E,
        completion: @escaping CompletionHandler<T>
    ) -> NetworkCancellable? where E.Response == T
    
    // 비동기 작업을 실행할 큐를 명시적으로 지정하지 않음

    @discardableResult
    func request<E: ResponseRequestable>(
        with endpoint: E,
        on queue: DataTransferDispatchQueue,
        completion: @escaping CompletionHandler<Void>
    ) -> NetworkCancellable? where E.Response == Void
    
    // 응답이 없는 요청을 수행
    
    @discardableResult
    func request<E: ResponseRequestable>(
        with endpoint: E,
        completion: @escaping CompletionHandler<Void>
    ) -> NetworkCancellable? where E.Response == Void
    
    // 응답이 없는 요청 + 큐 명시 X
}

protocol DataTransferErrorResolver {
    func resolve(error: NetworkError) -> Error
}

protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}



// 제네릭 타입 'T'에 대한 디코딩을 수행하며, 'Data'를 받아서 디코드된 결과를 반환한다.

protocol DataTransferErrorLogger {
    func log(error: Error)
}

// ================== class

final class DefaultDataTransferService {
    
    private let networkService: NetworkService
    private let errorResolver: DataTransferErrorResolver
    private let errorLogger: DataTransferErrorLogger
    
    init(
        with networkService: NetworkService,
        errorResolver: DataTransferErrorResolver = DefaultDataTransferErrorResolver(),
        errorLogger: DataTransferErrorLogger = DefaultDataTransferErrorLogger()
    ) {
        self.networkService = networkService
        self.errorResolver = errorResolver
        self.errorLogger = errorLogger
    }
}

extension DefaultDataTransferService: DataTransferService {
    
    func request<T: Decodable, E: ResponseRequestable>(
        with endpoint: E,
        on queue: DataTransferDispatchQueue,
        completion: @escaping CompletionHandler<T>
    ) -> NetworkCancellable? where E.Response == T {
        // json을 디코딩할 때 사용되는 DTO 가 Decodable 한지 확인. 타입 안정성을 위해 필요하다는데 잘 모르겠음
        print(T.self, E.self, "T타입은 뭐지?")
        return networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                
                let result: Result<T, DataTransferError> = self.decode(
                    data: data,
                    decoder: endpoint.responseDecoder
                )
                queue.asyncExecute { completion(result) }
            case .failure(let error):
                self.errorLogger.log(error: error)
                let error = self.resolve(networkError: error)
                queue.asyncExecute { completion(.failure(error)) }
            }
        }
    }
    
    func request<T: Decodable, E: ResponseRequestable>(
        with endpoint: E,
        completion: @escaping CompletionHandler<T>
    ) -> NetworkCancellable? where E.Response == T {
        request(with: endpoint, on: DispatchQueue.main, completion: completion)
    }
    
    // 사용자가 queue 매개변수를 생략했을 경우 상위의 Request 함수를 호출한다.
    
    
    
    
    
    
    
    
    // 위의 두 함수와 동일하지만 response가 비어있는 상황. completion handler에도 반환 값은 없음

    func request<E>(
        with endpoint: E,
        on queue: DataTransferDispatchQueue,
        completion: @escaping CompletionHandler<Void>
    ) -> NetworkCancellable? where E : ResponseRequestable, E.Response == Void {
        networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success:
                queue.asyncExecute { completion(.success(())) }
            case .failure(let error):
                self.errorLogger.log(error: error)
                let error = self.resolve(networkError: error)
                queue.asyncExecute { completion(.failure(error)) }
            }
        }
    }


    func request<E>(
        with endpoint: E,
        completion: @escaping CompletionHandler<Void>
    ) -> NetworkCancellable? where E : ResponseRequestable, E.Response == Void {
        request(with: endpoint, on: DispatchQueue.main, completion: completion)
    }
    
    

    // MARK: - Private
    private func decode<T: Decodable>(
        data: Data?,
        decoder: ResponseDecoder
    ) -> Result<T, DataTransferError> {
        do {
            guard let data = data else { return .failure(.noResponse) }
            let result: T = try decoder.decode(data)
            return .success(result)
        } catch {
            self.errorLogger.log(error: error)
            return .failure(.parsing(error))
        }
    }
    
    private func resolve(networkError error: NetworkError) -> DataTransferError {
        let resolvedError = self.errorResolver.resolve(error: error)
        return resolvedError is NetworkError
        ? .networkFailure(error)
        : .resolvedNetworkFailure(resolvedError)
    }
}

// MARK: - Logger
final class DefaultDataTransferErrorLogger: DataTransferErrorLogger {
    init() { }
    
    func log(error: Error) {
        printIfDebug("-------------")
        printIfDebug("\(error)")
    }
}

// MARK: - Error Resolver
class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
    init() { }
    func resolve(error: NetworkError) -> Error {
        return error
    }
}

// MARK: - Response Decoders
class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()
    init() { }
    func decode<T: Decodable>(_ data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
    // T.self는 디코딩할 타입 'T'를 나타내게 된다.
}

class RawDataResponseDecoder: ResponseDecoder {
    init() { }
    
    enum CodingKeys: String, CodingKey {
        case `default` = ""
    }
    func decode<T: Decodable>(_ data: Data) throws -> T {
        if T.self is Data.Type, let data = data as? T {
            return data
        // T가 데이터 타입인 경우를 확인하고, data를 T 타입으로 변환하여 반환한다.
        } else {
            let context = DecodingError.Context(
                codingPath: [CodingKeys.default],
                debugDescription: "Expected Data type"
            )
            throw Swift.DecodingError.typeMismatch(T.self, context)
            // 디코딩 에러를 전달한다.
        }
    }
}
