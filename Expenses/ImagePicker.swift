//
//  ImagePicker.swift
//  Expenses
//
//  Created by mahesh lad on 08/05/2024.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType?
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
   
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        if let sourceType = sourceType {
            picker.sourceType = sourceType
        }
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
}
