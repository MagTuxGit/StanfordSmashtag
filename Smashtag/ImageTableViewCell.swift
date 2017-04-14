//
//  ImageTableViewCell.swift
//  Smashtag
//
//  Created by Andrij Trubchanin on 4/14/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

import UIKit
import Twitter

class ImageTableViewCell: UITableViewCell {
    @IBOutlet weak var mediaView: UIImageView!
    
    var cellImage: UIImage? { didSet { updateUI() } }
    
    private func updateUI() {
        self.mediaView?.image = cellImage
    }
}
