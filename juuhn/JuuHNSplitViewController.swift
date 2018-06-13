//
//  JuuHNSplitViewController.swift
//  juuhn
//
//  Created by lex on 12/06/2018.
//  Copyright © 2018 Yuuh Ltd. All rights reserved.
//

import UIKit

class JuuHNSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    override func viewDidLoad() {
        self.delegate = self
        self.preferredDisplayMode = .allVisible
    }

    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool {
        // Return true to prevent UIKit from applying its default behavior
        return true
    }
}
