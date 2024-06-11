//
//  ImagePickerViewModel.swift
//  ImageAnimationWithText
//
//  Created by devang bhavsar on 19/03/22.
//

import UIKit
import PhotosUI
typealias typeSelectedImages = ([UIImage]) -> Void
class MultipleImagePickerViewModel: NSObject {
    var arrAllIamges = [UIImage]()
    var viewController:UIViewController?
    var selectedImage:typeSelectedImages?
    var numberOFImages:Int = 0
    func presentPicker() {
        // Create configuration for photo picker
        var configuration = PHPickerConfiguration()
        
        // Specify type of media to be filtered or picked. Default is all
        configuration.filter = .any(of: [.images,.livePhotos,.videos])
        
        // For unlimited selections use 0. Default is 1
        configuration.selectionLimit = numberOFImages
        
        // Create instance of PHPickerViewController
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
       // present(picker, animated: true)
        picker.modalPresentationStyle = .custom
        viewController!.present(picker, animated: true, completion: nil)
    }
    
    func display(image: UIImage? = nil, livePhoto: PHLivePhoto? = nil) {
        arrAllIamges.append(image!)
    }
    
    func managePHPickerResult(results : [PHPickerResult]) {
        if results.count > 0 {
            for result in results {
                let itemProvider = result.itemProvider
                // Parse Image
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                        DispatchQueue.main.async {
                            guard let self = self else { return }
                            if let image = image as? UIImage{
                                self.arrAllIamges.append(image)
                                self.selectedImage!(self.arrAllIamges)
                                // self.display(image: image)
                            }else {
                                // self.display(image: UIImage(systemName: "exclamationmark.circle"))
                            }
                        }
                    }
                }
            }
        }

        viewController?.dismiss(animated: true, completion: nil)
        // Parse Video
//        else if itemProvider.hasItemConformingToTypeIdentifier("com.apple.quicktime-movie") {
//            itemProvider.loadItem(forTypeIdentifier: "com.apple.quicktime-movie", options: nil) { [weak self] (fileURL, _) in
//                DispatchQueue.main.async {
//                    guard let videoURL = fileURL as? URL, let self = self else { return }
//                    self.display(videoWithURL: videoURL)
//                }
//            }
//        }
        
    }
}
// MARK: PHPickerViewControllerDelegate Methods
extension MultipleImagePickerViewModel: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // Always dismiss the picker first
        if !results.isEmpty { managePHPickerResult(results: results) } else {
            viewController?.dismiss(animated: true, completion: nil)
        }
    }

}
