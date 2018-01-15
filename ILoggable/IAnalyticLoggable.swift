//  IAnalyticLoggable.swift
//  ILoggable
//
//  MIT License
//
//  Copyright (c) 2018 Joanna Kasprzycka
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Impresyjna on 13.01.2018.
//  Copyright © 2018 Impresyjna. All rights reserved.
//

import Foundation
import UIKit

enum AnalyticEventType {
    case viewVisited
    case click(Any)
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
        case .click(let clickedObject):
            appendObjectClicked(clickedObject: clickedObject, params: params)
        }
    }
    
    func appendViewVisited(params: [String: Any]? = nil) {
        var parentId: Int = analyticView.id
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
    
    func appendObjectClicked(clickedObject: Any, params: [String: Any]? = nil) {
        if let button = clickedObject as? UIButton {
            print("Button clicked View id \(button.tag), parent id: \(analyticView.id)")
        }
//
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
