//
//  ProofTableViewCell.swift
//  Squat
//
//  Created by devang bhavsar on 28/02/22.
//

import UIKit

class ProofTableViewCell: UITableViewCell {

    @IBOutlet weak var imgProof: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
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
