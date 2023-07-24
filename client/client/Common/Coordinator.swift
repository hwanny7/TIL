import UIKit

// MARK: - Coordinator
protocol Coordinator: AnyObject {
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    
    var navigationController: UINavigationController { get set }
    
    var childCoordinators: [Coordinator] { get set }
  
    var type: CoordinatorType { get }
   
    func start()

    func finish()
    
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

// MARK: - CoordinatorOutput


protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}

// MARK: - CoordinatorType


enum CoordinatorType {
    case app, login, tab, home, search, user
}
