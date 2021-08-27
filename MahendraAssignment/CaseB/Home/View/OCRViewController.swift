//
//  OCRViewController.swift
//  MahendraAssignment
//
//  Created by Mahendra Vishwakarma on 26/08/21.
//

import UIKit
import Vision

class OCRViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblScannedText: UILabel!
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var btnOCR: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    var viewModel:OCRViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = OCRViewModel()
        viewModel?.delegate = self
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        btnOCR.isHidden = true
        
    }
    
    @IBAction func btnOCROperate(_ sender: Any) {
        if let image = imageView.image?.cgImage {
            self.loader.startAnimating()
            self.loader.isHidden = false
            btnOCR.isEnabled = false
            viewModel?.startOCR(image: image)
        }
    }
    
    @IBAction func btnGallery(_ sender: Any) {
        
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    @IBAction func btnCamera(_ sender: Any) {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension OCRViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
        btnOCR.isHidden = false
        guard let selectedImage = info[.editedImage] as? UIImage else {
            print("Image not found!")
            return
        }
        imageView.image = selectedImage
    }
}

extension OCRViewController:OCRTextDelegate {
    func updateData(text: String?) {
        DispatchQueue.main.async {
            self.lblScannedText.text = text
            self.loader.stopAnimating()
            self.btnOCR.isEnabled = true
        }
    }
}
