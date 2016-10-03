//
//  ViewController.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 10/01/2016.
//  Copyright (c) 2016 Florian Gabach. All rights reserved.
//

import UIKit
import GBHFacebookImagePicker

class ViewController: UIViewController, GBHFacebookImagePickerDelegate {
    
    @IBOutlet weak var pickerImageView: UIImageView!
    @IBOutlet weak var showAlbumButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Prepare picker button
        self.showAlbumButton.addTarget(self,
                                       action: #selector(self.showAlbumClick),
                                       for: UIControlEvents.touchUpInside)
        
        self.pickerImageView.contentMode = .scaleToFill
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlbumClick() {
        print(self, #function)
        
        // Init & Show picker
        let albumPicker = GBHFacebookImagePicker()
        albumPicker.delegate = self
        let navi = UINavigationController(rootViewController: albumPicker)
        self.present(navi, animated: true)
    }
    
    
    /**
    * Load the picked picture
    **/
    func loadPickedPicture(url: String) {
        if let url = URL(string: url) {
            URLSession.shared.dataTask(with: url as URL) { data, response, error in
                guard let data = data , error == nil else {
                    print("\nerror on download \(error)")
                    return
                }
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    print("statusCode != 200; \(httpResponse.statusCode)")
                    return
                }
                DispatchQueue.main.async {
                    self.pickerImageView.image = UIImage(data: data)
                }
                }.resume()
        }
    }
    
    // MARK: - GBHFacebookImagePicker Protocol
    
    func facebookImagePicker(imagePicker: UIViewController, didSelectImageWithUrl url: String) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        print("Image URL : \(url)")
        self.loadPickedPicture(url: url) // Load pic 
    }
    
    func facebookImagePicker(imagePicker: UIViewController, didFailWithError error: Error?) {
        print(error.debugDescription)
    }
    
    func facebookImagePicker(didCancelled imagePicker: UIViewController) {
        print("Cancelled Facebook Album picker")
    }

}
