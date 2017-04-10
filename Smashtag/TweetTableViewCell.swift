//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Andrij Trubchanin on 4/10/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Twitter.Tweet? { didSet { updateUI() } }
    
    private func updateUI() {
        tweetTextLabel?.text = tweet?.text
        tweetUserLabel?.text = tweet?.user.description
        
        if let profileImageURL = tweet?.user.profileImageURL {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let imageDataRequest = try? Data(contentsOf: profileImageURL)
                
                DispatchQueue.main.async {
                    if let imageData = imageDataRequest {
                        self?.tweetProfileImageView?.image = UIImage(data: imageData)
                    } else {
                        self?.tweetProfileImageView?.image = nil
                    }
                }
            }
            
            if let created = tweet?.created {
                let formatter = DateFormatter()
                if Date().timeIntervalSince(created) > 24*60*60 {
                    formatter.dateStyle = .short
                } else {
                    formatter.timeStyle = .short
                }
                tweetCreatedLabel?.text = formatter.string(from: created)
            } else {
                tweetCreatedLabel?.text = nil
            }
        }
    }
}
