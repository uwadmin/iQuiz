//
//  File.swift
//  iQuiz
//
//  Created by ​ on 11/11/17.
//  Copyright © 2017 iGuest. All rights reserved.
//

import Foundation
extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
