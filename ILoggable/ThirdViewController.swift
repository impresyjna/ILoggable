//
//  ThirdViewController.swift
//  ILoggable
//
//  Created by Impresyjna on 13.01.2018.
//  Copyright © 2018 Impresyjna. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, IAnalyticLoggable {
    var analyticView: AnalyticView = AnalyticViewNamespace.thirdView
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        appendEvent(type: .viewVisited)
    }

}
