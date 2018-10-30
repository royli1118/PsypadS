//
//  Fraction.swift
//  PsyPadS
//
//  Created by Roy Li on 30/09/18.
//  Copyright © 2018 David Lawson. All rights reserved.
//

import Foundation


class Fraction {

    var numerator: Float?
    var denominator: Float?
    

    init() {
        numerator = 0
        denominator = 0
    }
    
    func floatValue() -> Float {
        return (numerator as! Float / denominator! )
    }
    
}
