//
//  NewsCellTableViewCell.swift
//  TopNews
//
//  Created by Ilya Maier on 31.05.2020.
//  Copyright © 2020 mera. All rights reserved.
//

import UIKit

class NewsCellTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var heightMax: NSLayoutConstraint!
    @IBOutlet weak var heightMin: NSLayoutConstraint!

    var imageUrl = "";
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
