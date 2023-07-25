

import UIKit

enum TabBarPage {
    case home
    case search
    case profile

    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .search
        case 2:
            self = .profile
        default:
            return nil
        }
    }
    
    func getPageTitle() -> String {
        switch self {
        case .home:
            return "Home"
        case .search:
            return "Search"
        case .profile:
            return "Profile"
        }
    }

    func getPageNumber() -> Int {
        switch self {
        case .home:
            return 0
        case .search:
            return 1
        case .profile:
            return 2
        }
    }
}

class TabBarCoordinator: Coordinator {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var tabBarController: UITabBarController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        // DI가 필요 없을 것 같긴한데, 이 Coordinator를 DI가 만들어줘야해서, 그 용도로만 DI를 생성해야 하나?
    }

    func start() {
        let pages: [TabBarPage] = [.home, .search, .profile]

        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        
//        prepareTabBarController(withTabControllers: controllers)
    }
    
    
}


// --------------------------------------------------

protocol TabBarCoordinatorProtocol {
    
    var tabBarController: UITabBarController { get set }
    
    func selectPage(_ page: TabBarPage)
    
    func setSelectedIndex(_ index: Int)
    
    func currentPage() -> TabBarPage?
    
    
}

extension TabBarCoordinator: TabBarCoordinatorProtocol {
    
    var type: CoordinatorType { .tab }
    
    func currentPage() -> TabBarPage? {
        TabBarPage(index: tabBarController.selectedIndex)
    }

    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.getPageNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage(index: index) else { return }
        
        tabBarController.selectedIndex = page.getPageNumber()
    }
}

//// MARK: - UITabBarControllerDelegate
//extension TabCoordinator: UITabBarControllerDelegate {
//    func tabBarController(_ tabBarController: UITabBarController,
//                          didSelect viewController: UIViewController) {
//        // Some implementation
//    }
//}
//
