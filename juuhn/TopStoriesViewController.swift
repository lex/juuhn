//
//  ViewController.swift
//  juuhn
//
//  Created by lex on 03/06/2018.
//  Copyright © 2018 Yuuh Ltd. All rights reserved.
//

import UIKit

class StoryTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtext: UILabel!
}

protocol StorySelectionDelegate: class {
    func storySelected(_ newStory: Story)
}

class TopStoriesViewController: UIViewController {
    @IBOutlet weak var newsTableView: UITableView!
    weak var storySelectionDelegate: StorySelectionDelegate?

    let scraper = HNScraper()
    var stories: [Story] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.newsTableView.dataSource = self
        self.newsTableView.delegate = self

        scraper.scrapeTop(completionHandler: { stories in
            guard let stories = stories else {
                print("something went wrong")
                return
            }

            self.stories = stories
            self.newsTableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TopStoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let story = stories[index]

        let cell = self.newsTableView.dequeueReusableCell(withIdentifier: "StoryCell", for: indexPath) as! StoryTableViewCell
        cell.title.text = story.title
        cell.subtext.text = "\(story.score) by \(story.user) \(story.age) | \(story.comments)"

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = self.stories[indexPath.row]
        self.storySelectionDelegate?.storySelected(story)

        guard let storyViewController = self.storySelectionDelegate as? StoryViewController,
            let storyNavigationController = storyViewController.navigationController else {
                return
        }

        self.splitViewController?.showDetailViewController(storyNavigationController, sender: nil)
    }
}
