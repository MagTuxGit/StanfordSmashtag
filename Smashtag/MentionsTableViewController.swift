//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Andrij Trubchanin on 4/13/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

import UIKit
import Twitter

class MentionsTableViewController: UITableViewController {
    // MARK: Model
    
    var tweetMentions: [[Twitter.Mention]] = [[]] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweetMentions.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetMentions[section].count
        
//        if let curTweet = tweet {
//            switch section {
//            case 1 :
//                return curTweet.media.count
//            case 2:
//                return curTweet.hashtags.count
//            case 3:
//                return curTweet.userMentions.count
//            case 4:
//                return curTweet.urls.count
//            default:
//                return 0
//            }
//        }
//        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mentionCell", for: indexPath)

        cell.textLabel?.text = tweetMentions[indexPath.section][indexPath.row].keyword
        
        return cell
    }
}
