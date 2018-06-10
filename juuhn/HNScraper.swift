//
//  HNScraper.swift
//  juuhn
//
//  Created by lex on 10/06/2018.
//  Copyright © 2018 Yuuh Ltd. All rights reserved.
//

import Foundation
import Alamofire
import Kanna

class Story {
    let title: String
    let score: String
    let user: String
    let age: String
    let comments: String

    init(title: String, score: String, user: String, age: String, comments: String) {
        self.title = title
        self.score = score
        self.user = user
        self.age = age
        self.comments = comments
    }
}

class HNScraper {
    let URL_TOP = "https://news.ycombinator.com";

    func scrapeTop(completionHandler: @escaping ([Story]?) -> Void) {
        Alamofire.request(URL_TOP).responseString { response in
            if let html = response.result.value {
                do {
                    let stories: [Story] = try self.parseTop(html: html)
                    completionHandler(stories)
                } catch {
                    print("rip")
                    completionHandler(nil)
                }
            }

            completionHandler(nil)
        }
    }

    func parseTop(html: String) throws -> [Story] {
        var stories: [Story] = []

        let doc = try Kanna.HTML(html: html, encoding: String.Encoding.utf8)
        var titles: [String?] = doc.css(".storylink").map { title in title.text }

        let subtexts = doc.css(".subtext")
        for subtext in subtexts {
            if let title = titles.removeFirst(),
                let score = subtext.css(".score").first?.text,
                let user = subtext.css(".hnuser").first?.text,
                let age = subtext.css(".age").first?.text,
                let comments = subtext.css("a").reversed().first?.text {
                let story = Story(title: title, score: score, user: user, age: age, comments: comments)
                stories.append(story)
            }
        }

        return stories
    }
}
