
import UIKit

// MARK: - Protocol

protocol AppCoordinatorProtocol {
    func showMainFlow()
}

// MARK: - Coordinator

final class AppCoordinator: Coordinator {

    private let appDIConainer: AppDIContainer
    // Coordinator 프로토콜에 추가하지 않아도 괜찮은걸까?
    var navigationController: UINavigationController
    
    weak var finishDelegate: CoordinatorFinishDelegate? = nil

    
    var childCoordinators = [Coordinator]()
    
    var type: CoordinatorType { .app }
    
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ){
        self.navigationController = navigationController
        self.appDIConainer = appDIContainer
    }
    
    func start() {
        
    }
    
    
}

// MARK: - Extension

extension AppCoordinator: AppCoordinatorProtocol {
    func showMainFlow(){
        
    }
}


extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        // 만약 끝난 Coordinator가 login일 경우 login을 모두 지운다. (다음에 못 돌아가게 하려고?)

        switch childCoordinator.type {
        case .tab:
            navigationController.viewControllers.removeAll()
//            showLoginFlow()
        case .login:
            navigationController.viewControllers.removeAll()

            showMainFlow()
        default:
            break
        }
    }
}
