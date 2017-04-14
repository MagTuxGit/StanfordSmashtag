//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Andrij Trubchanin on 4/10/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

import UIKit
import Twitter

// make a Workspace that includes both this application and the Twitter project
// drag the Product of the Twitter framework build into the Embedded Binaries section of the Project Settings of this application

class TweetTableViewController: UITableViewController, UITextFieldDelegate {

    // MARK: Model
    
    // sections of tweets
    // you can use Tweet as long as you don't have your own Tweet class
    private var tweets = [Array<Twitter.Tweet>]()
    
    // public part
    var searchText: String? {
        didSet {
            searchTextField?.text = searchText
            searchTextField?.resignFirstResponder()
            
            lastTwitterRequest = nil
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            title = searchText
        }
    }
    
    // MARK: Updating the table
    
    private func twitterRequest() -> Twitter.Request? {
        if let query = searchText, !query.isEmpty {
            return Twitter.Request(search: "\(query) -filter:safe -filter:retweets", count: 100)
        }
        return nil
    }
    
    // ignore tweets that come back from other than our last request
    // when we want to refresh, we only get tweets newer than our last request
    private var lastTwitterRequest: Twitter.Request?

    // fetch Tweets, update the Tweets array, update the Table
    private func searchForTweets() {
        if let request = lastTwitterRequest?.newer ?? twitterRequest() {
            lastTwitterRequest = request
            request.fetchTweets { [weak self] newTweets in
                DispatchQueue.main.async {
                    // dispatch it back because tableView is an UI stuff
                    if request == self?.lastTwitterRequest {
                        self?.tweets.insert(newTweets, at: 0)
                        self?.tableView.insertSections([0], with: .fade)
                    }
                    self?.refreshControl?.endRefreshing()
                }
            }
        } else {
            self.refreshControl?.endRefreshing()
        }
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        searchForTweets()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // we use the row height in the storyboard as an "estimate"
        tableView.estimatedRowHeight = tableView.rowHeight
        // but use whatever autolayout says the height should be as the actual row height
        tableView.rowHeight = UITableViewAutomaticDimension
        // the row height could alternatively be set
        // using the UITableViewDelegate method heightForRowAt
    }
    
    // MARK: Search Text Field
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    // return pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchText = searchTextField.text
        }
        return true
    }
    
    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweet", for: indexPath)
        
        // get the tweet that is associated with this row
        let tweet = tweets[indexPath.section][indexPath.row]
        
        // non-Custon cells
        //cell.textLabel?.text = tweet.text
        //cell.detailTextLabel?.text = tweet.user.name
        
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(tweets.count-section)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "showMentions" {
                if let mentionsVC = segue.destination as? MentionsTableViewController,
                    let selectedCell = sender as? TweetTableViewCell,
                    let indexPath = tableView.indexPath(for: selectedCell) {
                        let tweet = tweets[indexPath.section][indexPath.row]
                        mentionsVC.tweet = tweet
                }
            }
        }
    }
}
