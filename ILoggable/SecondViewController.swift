//
//  SecondViewController.swift
//  ILoggable
//
//  Created by Impresyjna on 13.01.2018.
//  Copyright © 2018 Impresyjna. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, IAnalyticLoggable {
    var analyticView: AnalyticView = AnalyticViewNamespace.secondView

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        appendEvent(type: .viewVisited)
    }

    @IBAction func presentViewController(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ThirdViewController")
        self.present(controller, animated: true)
        
    }
    
}
