//
//  ImageSliderCollectionViewCell.swift
//  Squat
//
//  Created by devang bhavsar on 22/02/22.
//

import UIKit

class ImageSliderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgSlider: UIImageView!
    override func prepareForReuse() {
       // self.imgSlider.sd_cancelCurrentImageLoad()
        imgSlider.image = nil
    }
}
