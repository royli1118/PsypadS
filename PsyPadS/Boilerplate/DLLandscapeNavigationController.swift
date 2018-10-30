//
//  DLLandscapeNavigationController.swift
//  PsyPadS
//
//  Created by Roy Li on 15/09/18.
//  Copyright © 2018 David Lawson. All rights reserved.
//

import Foundation


class DLLandscapeNavigationController: UINavigationController {

    func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .landscape
    }
}
