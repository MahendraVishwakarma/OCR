//
//  ORCViewModel.swift
//  MahendraAssignment
//
//  Created by Mahendra Vishwakarma on 26/08/21.
//

import Foundation
import Vision

class OCRViewModel {
    weak var delegate:OCRTextDelegate?
    func startOCR(image:CGImage) {
        DispatchQueue.global().async {
            let requestHandler = VNImageRequestHandler(cgImage: image)
            let request = VNRecognizeTextRequest { (request, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                let scannedText = self.recognizeText(from: request)
                self.delegate?.updateData(text: scannedText)
               
                print(scannedText ?? "")
            }
            do {
                try requestHandler.perform([request])
            } catch {
                print("Unable to perform the requests: \(error).")
            }
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
    
}

protocol OCRTextDelegate:AnyObject {
    func updateData(text:String?)
}
