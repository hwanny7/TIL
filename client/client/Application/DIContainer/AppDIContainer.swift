import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    
    // MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: appConfiguration.apiBaseURL)!,
            queryParameters: [
                "api_key": appConfiguration.apiKey,
                "language": NSLocale.preferredLanguages.first ?? "en"
            ]
        )
        
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
//    lazy var imageDataTransferService: DataTransferService = {
//        let config = ApiDataNetworkConfig(
//            baseURL: URL(string: appConfiguration.imagesBaseURL)!
//        )
//        let imagesDataNetwork = DefaultNetworkService(config: config)
//        return DefaultDataTransferService(with: imagesDataNetwork)
//    }()
    
    // MARK: - DIContainers of scenes
//    func makeMoviesSceneDIContainer() -> MoviesSceneDIContainer {
//        let dependencies = MoviesSceneDIContainer.Dependencies(
//            apiDataTransferService: apiDataTransferService,
//            imageDataTransferService: imageDataTransferService
//        )
//        // dependencies 구조체를 만든다.
//        return MoviesSceneDIContainer(dependencies: dependencies)
//    }
    
    func makeTabBarDIContainer() -> Void {
        
    }
    
    func makeLoginSceneDIContainer() -> Void {
        
    }
    
}
