//
//  DLPortraitNavigationController.swift
//  PsyPadS
//
//  Created by Roy Li on 03/10/18.
//  Copyright © 2018 David Lawson. All rights reserved.
//

import Foundation


class DLPortraitNavigationController: UINavigationController {

    func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .portrait
    }
}
