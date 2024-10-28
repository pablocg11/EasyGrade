//
//  ContentView.swift
//  ScanGrater
//
//  Created by Pablo on 29/6/24.
//

import SwiftUI
import CoreImage
import UIKit

struct ImageComparisonView: View {
    @State private var studentImage: UIImage?
    @State private var templateImage: UIImage?
    @State private var comparisonResult: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                // Load student's image (replace with your image loading logic)
                self.studentImage = UIImage(named: "student_answer") // Replace with your image loading logic
            }) {
                Text("Load Student's Answer")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: {
                // Load answer template image (replace with your image loading logic)
                self.templateImage = UIImage(named: "answer_template") // Replace with your image loading logic
            }) {
                Text("Load Answer Template")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            if let studentImage = studentImage, let templateImage = templateImage {
                Image(uiImage: studentImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                
                Image(uiImage: templateImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                
                Button(action: {
                    // Compare images
                    self.compareImages()
                }) {
                    Text("Compare Images")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Text(comparisonResult)
                    .padding()
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding()
    }
    
    func compareImages() {
        guard let studentImage = studentImage, let templateImage = templateImage else {
            return
        }
        
        // Convert images to CIImage
        guard let ciStudentImage = CIImage(image: studentImage),
              let ciTemplateImage = CIImage(image: templateImage) else {
            return
        }
        
        // Create CIContext
        let context = CIContext()
        
        // Create CIFilter to convert to grayscale
        let grayFilter = CIFilter(name: "CIColorControls")
        grayFilter?.setValue(ciStudentImage, forKey: kCIInputImageKey)
        grayFilter?.setValue(0.0, forKey: kCIInputSaturationKey)
        if let outputImage = grayFilter?.outputImage {
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
            
            // Convert the processed image to a UIImage
            let processedImage = UIImage(cgImage: cgImage!)
            
            // Display the processed image
            self.studentImage = processedImage
        }
        
        // Compare pixel by pixel
        let studentPixelData = studentImage.cgImage!.dataProvider!.data
        let templatePixelData = templateImage.cgImage!.dataProvider!.data
        
        let studentPixels: UnsafePointer<UInt8> = CFDataGetBytePtr(studentPixelData)
        let templatePixels: UnsafePointer<UInt8> = CFDataGetBytePtr(templatePixelData)
        
        var differencesCount = 0
        let pixelCount = Int(ciStudentImage.extent.width * ciStudentImage.extent.height)
        
        for i in 0 ..< pixelCount * 4 { // 4 bytes per pixel (RGBA)
            if studentPixels[i] != templatePixels[i] {
                differencesCount += 1
            }
        }
        
        // Determine if images are similar based on differences count
        let similarityThreshold = 0.01 // Adjust as needed
        if Double(differencesCount) / Double(pixelCount * 4) < similarityThreshold {
            self.comparisonResult = "Images are similar"
        } else {
            self.comparisonResult = "Images are not similar"
        }
    }
}



