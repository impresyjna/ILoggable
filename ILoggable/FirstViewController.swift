//
//  ViewController.swift
//  ILoggable
//
//  Created by Impresyjna on 13.01.2018.
//  Copyright © 2018 Impresyjna. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, IAnalyticLoggable {
    var analyticView: AnalyticView = AnalyticViewNamespace.firstView
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        appendEvent(type: .viewVisited)
    }

    
    @IBAction func pushSecondView(_ sender: Any) {
        appendEvent(type: .click(sender))
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SecondViewController")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

