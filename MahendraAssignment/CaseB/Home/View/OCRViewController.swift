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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        btnOCR.isHidden = true
    }
    
    @IBAction func btnOCROperate(_ sender: Any) {
        if let image = imageView.image?.cgImage {
            self.loader.startAnimating()
            self.startOCR(image: image) {
                self.loader.stopAnimating()
            }
            
            
        }
        
    }
    
    private func startOCR(image: CGImage,handler:(()-> Void)) {
        let requestHandler = VNImageRequestHandler(cgImage: image)
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            let scannedText = self.recognizeText(from: request)
           
            DispatchQueue.main.async {
                self.lblScannedText.text = scannedText
                self.loader.stopAnimating()
            }
            print(scannedText ?? "")
        }
        do {
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
       
    }
    
    private func recognizeText(from request: VNRequest) -> String? {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return nil
        }
        
        let recognizedStrings: [String] = observations.compactMap { (observation)  in
            guard let topCandidate = observation.topCandidates(1).first else { return nil }
            
            return topCandidate.string.trimmingCharacters(in: .whitespaces)
        }
        
        return recognizedStrings.joined(separator: "\n")
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
