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
    
    private var tweetMentions: [(title: String, items: [CellItems])] = [] { didSet { tableView.reloadData() } }

    private enum CellItems {
        case media(Twitter.MediaItem)
        case mention(Twitter.Mention)
        
        // for test purposes
        var description: String {
            switch self {
            case .media(let item):
                return item.description
            case .mention(let item):
                return item.description
            }
        }
    }
    
    // public API
    var tweet: Twitter.Tweet? {
        didSet {
            tweetMentions += [("Images", tweet?.media.map { CellItems.media($0) } ?? [])]
            tweetMentions += [("Hashtags", tweet?.hashtags.map { CellItems.mention($0) } ?? [])]
            tweetMentions += [("Users", tweet?.userMentions.map { CellItems.mention($0) } ?? [])]
            tweetMentions += [("URLs", tweet?.urls.map { CellItems.mention($0) } ?? [])]
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweetMentions.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetMentions[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tweetMentions[section].title
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mediaItem = tweetMentions[indexPath.section].items[indexPath.row]
        
        switch mediaItem {
        case .media(let item):
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath)
            if let imageCell = cell as? ImageTableViewCell {
                DispatchQueue.global(qos: .userInitiated).async {
                    let imageDataRequest = try? Data(contentsOf: item.url)
                    
                    DispatchQueue.main.async {
                        if let imageData = imageDataRequest {
                            imageCell.cellImage = UIImage(data: imageData)
                        } else {
                            imageCell.cellImage = nil
                        }
                    }
                }
            }
            return cell
        case .mention(let item):
            let cell = tableView.dequeueReusableCell(withIdentifier: "mentionCell", for: indexPath)
            cell.textLabel?.text = item.keyword
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mediaItem = tweetMentions[indexPath.section].items[indexPath.row]
        
        switch mediaItem {
        case .media(let item):
            return tableView.contentSize.width / CGFloat(item.aspectRatio)
        case .mention:
            return UITableViewAutomaticDimension
        }
    }
}
