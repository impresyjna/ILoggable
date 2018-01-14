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

enum WhichNavController: Int {
    case current = 1
    case previous = 2
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
            if let pController = getViewControllerFromNav(navController: navController) {
                parentId = pController.analyticView.id
            }
        } else if let presentingViewContoller = self.presentingViewController as? UINavigationController {
            if let pController = getViewControllerFromNav(navController: presentingViewContoller, which: .current) {
                parentId = pController.analyticView.id
            }
        } else if let presentViewContoller = self.presentingViewController, let pController = presentViewContoller as? IAnalyticLoggable {
            parentId = pController.analyticView.id
        }
        print(prepareParams(eventParams: [AnalyticEventNamespace.parentView: parentId, AnalyticEventNamespace.childView: analyticView.id], extraParams: params))
        print("View id \(analyticView.id), parent id: \(parentId)")
    }
    
    func appendButtonClicked(buttonId: Int, params: [String: Any]? = nil) {
        print("Button clicked View id \(buttonId), parent id: \(analyticView.id)")
    }
    
    func getViewControllerFromNav(navController: UINavigationController?, which: WhichNavController = .previous) -> IAnalyticLoggable? {
        guard let navController = navController else {
            return nil
        }
        
        let count = navController.viewControllers.count
        if count - which.rawValue >= 0, let pController = navController.viewControllers[count - which.rawValue] as? IAnalyticLoggable {
            return pController
        }
        
        return nil
    }
    
    func prepareParams(eventParams: [String: Any], extraParams: [String: Any]?) -> [String: Any] {
        var params: [String: Any] = [:]
        params[AnalyticEventNamespace.timestamp] = Date()
        
        for (key, value) in eventParams {
            params[key] = value
        }
        
        if let eParams = extraParams {
            for (key, value) in eParams {
                params[key] = value
            }
        }
        
        return params
    }
}
