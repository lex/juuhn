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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var newsTableView: UITableView!

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
