//
//  Coordinator.swift
//  Coordinator_Pattern
//
//  Created by yun on 2023/07/16.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get }
    
    func start()
}
