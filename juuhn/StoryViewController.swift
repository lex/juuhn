//
//  StoryViewController.swift
//  juuhn
//
//  Created by lex on 12/06/2018.
//  Copyright © 2018 Yuuh Ltd. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController {
    var story: Story? {
        didSet {
            self.title = story?.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension StoryViewController: StorySelectionDelegate {
    func storySelected(_ newStory: Story) {
        self.story = newStory
    }
}
