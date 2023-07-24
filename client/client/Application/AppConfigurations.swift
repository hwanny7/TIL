import Foundation

final class AppConfiguration {
    lazy var apiKey: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "ApiKey") as? String else {
            fatalError("ApiKey must not be empty in plist")
        }
        return apiKey
    }()
    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
    lazy var imagesBaseURL: String = {
        guard let imageBaseURL = Bundle.main.object(forInfoDictionaryKey: "ImageBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return imageBaseURL
    }()
}

// lazy 키워드를 사용할 경우 해당 프로퍼티에 접근할 때까지 해당 코드 블록이 실행되지 않는다.
// Bundle.main.object 메서드를 통해 Info.plist 에서 설정값을 가져온다.
// 설정값은 Any? 이기 때문에 String으로 타입캐스팅을 진행한다.
