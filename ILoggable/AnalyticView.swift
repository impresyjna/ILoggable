//
//  AnalyticView.swift
//  ILoggable
//
//  Created by Impresyjna on 13.01.2018.
//  Copyright © 2018 Impresyjna. All rights reserved.
//

import Foundation

struct AnalyticView {
    let id: Int
}

enum AnalyticViewNamespace {
    static let firstView = AnalyticView(id: 1)
    static let secondView = AnalyticView(id: 2)
    static let thirdView = AnalyticView(id: 3)
}
