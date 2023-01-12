//
//  ViewController.swift
//  MemeMe-Project
//
//  Created by TEJAKO3-Old Mac on 04/01/23.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var memeImage: UIImageView!
    
    @IBOutlet weak var cameraBtn: UIBarButtonItem!
    @IBOutlet weak var imageTopTxt: UITextField!
    @IBOutlet weak var imageBottomTxt: UITextField!
    
    var memedImage: memedImage!
    
    let txtFieldDelegate = TopNBottomTxtFieldsDelegates()
    
    let memTxtAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -1,
    ]
    
    struct memeImageInfo {
    var topText: String,
        bottomText: String,
        originalImage: UIImage
    }
    
    struct memedImage {
    var memedImage: UIImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cameraBtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        imageTopTxt.isHidden = true
        imageTopTxt.text = "TOP".uppercased()
        imageTopTxt.defaultTextAttributes = memTxtAttributes
        imageTopTxt.textColor = UIColor.white
        imageTopTxt.textAlignment = .center
        imageTopTxt.delegate = txtFieldDelegate
        
        
        imageBottomTxt.isHidden = true
        imageBottomTxt.text = "Bottom".uppercased()
        imageBottomTxt.defaultTextAttributes = memTxtAttributes
        imageBottomTxt.textColor = UIColor.white
        imageBottomTxt.textAlignment = .center
        imageBottomTxt.delegate = txtFieldDelegate
        
        
    }
    
    @IBAction func cancelAndReset(){
        imageTopTxt.text = "TOP".uppercased()
        imageBottomTxt.text = "Bottom".uppercased()
        imageTopTxt.isHidden = true
        imageBottomTxt.isHidden = true
        memeImage.image = nil
    }
    
    @IBAction func pickAnImageFromGallery(){
        let uiImagePickerController = UIImagePickerController()
        uiImagePickerController.delegate = self
        uiImagePickerController.sourceType = .savedPhotosAlbum
        uiImagePickerController.mediaTypes = ["public.image"]
        present(uiImagePickerController, animated: true)
    }
    
    
    @IBAction func pickImageFromCamera(){
        print("camera action triggered")
        let uiImagePickerController = UIImagePickerController()
        uiImagePickerController.delegate = self
        uiImagePickerController.sourceType = .camera
        uiImagePickerController.showsCameraControls = true
        uiImagePickerController.mediaTypes = ["public.image"]
        present(uiImagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage != nil){
            memeImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            imageTopTxt.isHidden = false
            imageBottomTxt.isHidden = false
            dismiss(animated: true)
        }
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification){
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
   
    @objc func keyboardWillHide(_ notification: Notification){
        view.frame.origin.y = 0
    }
    
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func save(){
        let meme = memeImageInfo(topText: imageTopTxt.text!, bottomText: imageBottomTxt.text!, originalImage: memeImage.image!)
       // self.memedImage.memedImage = getGeneratedMemeImage()
    }
    func captureIMageFromUIview() -> UIImage?{
        
        var screenShort : UIImage?
        let layer = self.view.layer
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
        self.view.drawHierarchy(in: layer.bounds, afterScreenUpdates: true)
        screenShort = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenShort
    }
    @IBAction func shareFinalMemeImageViaActivityController(){
       
        self.navigationController?.navigationBar.isHidden = true
        
        memeImage.image = captureIMageFromUIview()
//
//
//
//
//        let controller = UIActivityViewController(activityItems: [captureIMageFromUIview()], applicationActivities: nil)
//        present(controller, animated: true)
    }
    func getGeneratedMemeImage() -> UIImage{
        
        // TODO: Hide toolbar and navbar
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let finalMemeImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        
        return finalMemeImage
    }
    
    

}
