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

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        var stories: [(String, String, String, String, String)] = []
        
        let doc = try Kanna.HTML(html: html, encoding: String.Encoding.utf8)
        var titles: [String?] = doc.css(".storylink").map { title in title.text }
        
        let subtexts = doc.css(".subtext")
        for subtext in subtexts {
            if let title = titles.removeFirst(),
                let score = subtext.css(".score").first?.text,
                let age = subtext.css(".age").first?.text,
                let user = subtext.css(".hnuser").first?.text,
                let comments = subtext.css("a").reversed().first?.text {
                stories.append((title, score, age, user, comments))
            }
        }
        
        print(stories)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
