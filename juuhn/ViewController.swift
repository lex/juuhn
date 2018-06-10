//
//  ViewController.swift
//  juuhn
//
//  Created by lex on 03/06/2018.
//  Copyright © 2018 Yuuh Ltd. All rights reserved.
//

import UIKit
import Alamofire
import Kanna

class StoryTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtext: UILabel!
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var newsTableView: UITableView!

    var stories: [(String, String, String, String, String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.newsTableView.dataSource = self
        self.newsTableView.delegate = self

        scrapeHN();
    }
    
    func scrapeHN() {
        let url = "https://news.ycombinator.com";
        
        Alamofire.request(url).responseString { response in
            if let html = response.result.value {
                do {
                    try self.parseHTML(html: html)
                } catch {
                    print("rip")
                }
            }
        }
    }
    
    func parseHTML(html: String) throws {
        let doc = try Kanna.HTML(html: html, encoding: String.Encoding.utf8)
        var titles: [String?] = doc.css(".storylink").map { title in title.text }
        
        let subtexts = doc.css(".subtext")
        for subtext in subtexts {
            if let title = titles.removeFirst(),
                let score = subtext.css(".score").first?.text,
                let user = subtext.css(".hnuser").first?.text,
                let age = subtext.css(".age").first?.text,
                let comments = subtext.css("a").reversed().first?.text {
                stories.append((title, score, user, age, comments))
            }
        }
        
        print(stories)
        self.newsTableView.reloadData()
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
        cell.title.text = story.0
        cell.subtext.text = "\(story.1) by \(story.2) \(story.3) | \(story.4)"

        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
