//
//  CustomTableViewCell.swift
//  ImageAnimationWithText
//
//  Created by devang bhavsar on 14/03/22.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var viewContent: CUIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        self.selectionStyle = .none
    }

}
