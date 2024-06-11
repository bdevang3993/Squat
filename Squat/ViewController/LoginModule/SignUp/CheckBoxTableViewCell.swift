//
//  CheckBoxTableViewCell.swift
//  AllInOneTravels
//
//  Created by devang bhavsar on 08/12/21.
//

import UIKit
class CheckBoxTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnCheckBox: UIButton!
    var selectedIndex:taSelectedIndex?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        lblDescription.textColor = hexStringToUIColor(hex: "C3714B")
    }
    
    @IBAction func btnCheckBoxClicked(_ sender: UIButton) {
        selectedIndex!(sender.tag)
    }
    
}
