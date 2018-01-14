//
//  IAnalyticLoggable.swift
//  ILoggable
//
//  Created by Impresyjna on 13.01.2018.
//  Copyright © 2018 Impresyjna. All rights reserved.
//

import Foundation
import UIKit

enum AnalyticEventType {
    case viewVisited
    case click(Int)
}

enum AnalyticEventNamespace {
    static let timestamp = "timestamp"
    static let parentView = "parent_view"
    static let childView = "child_view"
    static let buttonView = "button_id"
}

protocol IAnalyticLoggable: class {
    var analyticView: AnalyticView { get }
    
    func appendEvent(type: AnalyticEventType, params: [String: Any]?)
}

extension IAnalyticLoggable where Self: UIViewController {
    func appendEvent(type: AnalyticEventType, params: [String: Any]? = nil) {
        switch type {
        case .viewVisited:
            appendViewVisited(params: params)
        case .click(let buttonId):
            appendButtonClicked(buttonId: buttonId, params: params)
        }
    }
    
    func appendViewVisited(params: [String: Any]? = nil) {
        var parentId: Int = 0
        if let navController = navigationController {
            if let pController = getPreviousViewController(navController: navController) {
                parentId = pController.analyticView.id
            }
        } else if let presentingViewContoller = self.presentingViewController as? UINavigationController {
            if let pController = getPreviousViewController(navController: presentingViewContoller) {
                parentId = pController.analyticView.id
            }
        }
        print("View id \(analyticView.id), parent id: \(parentId)")
    }
    
    func appendButtonClicked(buttonId: Int, params: [String: Any]? = nil) {
        print("Appending button clicked")
    }
    
    func getPreviousViewController(navController: UINavigationController?) -> IAnalyticLoggable? {
        guard let navController = navController else {
            return nil
        }
        
        let count = navController.viewControllers.count
        if count - 2 >= 0, let pController = navController.viewControllers[count - 2] as? IAnalyticLoggable {
            return pController
        }
        
        return nil
    }
}
