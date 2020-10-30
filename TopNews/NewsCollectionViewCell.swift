//
//  NewsCollectionViewCell.swift
//  TopNews
//
//  Created by Ilya Maier on 30.10.2020.
//  Copyright © 2020 mera. All rights reserved.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var imageUrl = "";
}
