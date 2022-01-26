//
//  ImageDataModel.swift
//  iReceipt
//
//  Created by Federico on 26/01/2022.
//

import Foundation
import SwiftUI

struct ImageNote : Codable, Hashable, Identifiable {
    var id = UUID()
    var image: Data
    var title: String
    var description: String
}

@MainActor class ImageData : ObservableObject {
    private let IMAGES_KEY = "ImagesKey"
    var imageNote: [ImageNote] {
        didSet {
            saveData()
            objectWillChange.send()
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: IMAGES_KEY) {
            if let decodedNotes = try? JSONDecoder().decode([ImageNote].self, from: data) {
                imageNote = decodedNotes
                print(imageNote)
                return
            }
        }
        imageNote = []
    }
    
    func addNote(image: UIImage, title: String, desc: String) {
        if let pngRepresentation = image.pngData() {
            
            let tempNote = ImageNote(image: pngRepresentation, title: title, description: desc)
            imageNote.insert(tempNote, at: 0)
            print(imageNote)
            saveData()
        }
    }
    
    private func saveData() {
        if let encodedNotes = try? JSONEncoder().encode(imageNote) {
            UserDefaults.standard.set(encodedNotes, forKey: IMAGES_KEY)
        }
    }
    
}
