//
//  FeedPostTableViewCell.swift
//  Natife_TT
//
//  Created by Jane Strashok on 25.10.2023.
//

import UIKit

class FeedPostTableViewCell: UITableViewCell {

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    var didExpandButtonPressed: (() -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onExpandButtonTouched(_ sender: Any) {
        if postText.numberOfLines == 2 {
            postText.numberOfLines = 0
            expandButton.setTitle("Collapse", for: .normal)
        } else {
            postText.numberOfLines = 2
            expandButton.setTitle("Expand", for: .normal)
        }
        
        didExpandButtonPressed?()
    }
}
