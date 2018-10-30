//
//  DLScrollView.swift
//  PsyPadS
//
//  Created by Roy Li on 30/10/18.
//  Copyright © 2018 David Lawson. All rights reserved.
//

import Foundation

class DLScrollView : UIScrollView {

    func touchesShouldCancelinView(view: UIView) -> Bool {
        return true
    }
}
