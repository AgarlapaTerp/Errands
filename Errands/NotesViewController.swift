//
//  NotesViewController.swift
//  Errands
//
//  Created by user256510 on 4/20/24.
//

import UIKit

class NotesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var note: UITextView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var mapPin: MapPin?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let mapPin {
            self.title = mapPin.title
            if let paragraph = mapPin.note {
                note.attributedText = paragraph
            }
        }
        
        let addPictureButton = UIBarButtonItem(title: "Add Picture", image: UIImage(systemName: "photo.badge.plus") , target: self, action: #selector(addNewPicture))
        let shareNoteButton = UIBarButtonItem(title: "Share Note", image: UIImage(systemName: "square.and.arrow.up"), target: self, action: #selector(shareNote))
        
        navigationItem.rightBarButtonItems = [addPictureButton, shareNoteButton]
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let mapPin {
            self.title = mapPin.title
            if let paragraph = mapPin.note {
                note.attributedText = paragraph
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let mapPin {
            mapPin.note = note.attributedText
            
            try? context.save()
        }
    }
    
    @objc func shareNote() {
        if let text = note.attributedText {
            let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
            present(vc,animated: true)
        }
    }
    
    @objc func addNewPicture () {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker,animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //writing to documents directory, so we don't lose the image if the user deletes the image from thier phone
        guard let image = info[.editedImage] as? UIImage else {return}
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        //load that same image from documents directory into the text view, then dismiss the pickercontroller
        let attachmentImage = UIImage(contentsOfFile: imagePath.path)
        
        //sizing the image so that it doesn't take up whole screen on notes
        
        // Calculate the aspect ratio for the image
        let aspectRatio = attachmentImage!.size.width / attachmentImage!.size.height

        // Define the maximum width or height for the image
        let maxWidth: CGFloat = 300 // Maximum width for the image
        let maxHeight: CGFloat = 300 // Maximum height for the image

        // Calculate the new size for the image based on the aspect ratio and the maximum width or height
        var imageSize = CGSize(width: maxWidth, height: maxHeight)
        if aspectRatio > 1 { // Landscape orientation
            imageSize.height = maxWidth / aspectRatio
        } else { // Portrait orientation
            imageSize.width = maxHeight * aspectRatio
        }
        
        
        
        if let attachmentImage = attachmentImage {
            let attachment = NSTextAttachment(image: attachmentImage)
            attachment.bounds = CGRect(origin: .zero, size: imageSize)
            
            let attributedString = NSAttributedString(attachment: attachment)
            let mutableAttributedString = NSMutableAttributedString(attributedString: note.attributedText)
            mutableAttributedString.append(attributedString)
            
            note.attributedText = mutableAttributedString
            
        }
        
        dismiss(animated:true)
    }
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }


}
