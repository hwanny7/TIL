//
//  MainCoordinator.swift
//  Coordinator_Pattern
//
//  Created by yun on 2023/07/16.
//

import Foundation
import UIKit


class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ViewController.instantiate()
        vc.coordinator = self
        // 해당 controller coordinator 프로퍼티에 MainCoordinator를 등록해준다.
        navigationController.pushViewController(vc, animated: false)
    }
    
    func buyTapped() {
        let vc = BuyViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func createAccount() {
        let vc = CreateAccountViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
}
