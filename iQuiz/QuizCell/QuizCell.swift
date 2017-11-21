//
//  QuizCell.swift
//  iQuiz
//
//  Created by ​ on 11/5/17.
//  Copyright © 2017 iGuest. All rights reserved.
//

import UIKit

class QuizCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var score: UILabel! {
        didSet {
            score.layer.cornerRadius = score.frame.width / 2
            score.layer.masksToBounds = true
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
