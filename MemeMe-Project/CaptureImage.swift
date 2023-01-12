//
//  ViewController.swift
//  MemeMe-Project
//
//  Created by TEJAKO3-Old Mac on 04/01/23.
//

import UIKit

class CaptureImage: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imgViewOutPut: UIImageView!
    
    @IBOutlet weak var pickImageAlertLabel: UILabel!
    
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    
    @IBOutlet weak var viewImageCapture: UIView!
    @IBOutlet weak var memeImage: UIImageView!
    
    @IBOutlet weak var cameraBtn: UIBarButtonItem!
    @IBOutlet weak var imageTopTxt: UITextField!
    @IBOutlet weak var imageBottomTxt: UITextField!
    
    
    let txtFieldDelegate = TopNBottomTxtFieldsDelegates()
    
    let memTxtAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -1,
    ]
    
    struct Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
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
        setScreenStyling()
    }
    
    func setScreenStyling(){
        
        cameraBtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        if(memeImage.image == nil){
            shareBtn.isEnabled = false
            pickImageAlertLabel.isHidden = false
        }
        
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
        shareBtn.isEnabled = false
        pickImageAlertLabel.isHidden = false
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
            setAndAllowMemeCreation(pickedImage: info[UIImagePickerController.InfoKey.originalImage] as! UIImage)
            dismiss(animated: true)
        }
    }
    
    func setAndAllowMemeCreation(pickedImage: UIImage){
        memeImage.image = pickedImage
        imageTopTxt.isHidden = false
        imageBottomTxt.isHidden = false
        imageTopTxt.text = "TOP".uppercased()
        imageBottomTxt.text = "Bottom".uppercased()
        shareBtn.isEnabled = true
        pickImageAlertLabel.isHidden = true
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
    
    func captureIMageFromUIview() -> UIImage?{
        
        var screenShort : UIImage?
        let layer = viewImageCapture.layer
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
        viewImageCapture.drawHierarchy(in: layer.bounds, afterScreenUpdates: true)
        screenShort = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenShort
    }
    @IBAction func shareFinalMemeImageViaActivityController(){
       
        self.navigationController?.navigationBar.isHidden = true
//        imgViewOutPut.image = captureIMageFromUIview()
//        viewImageCapture.isHidden = true
        
          

        let controller = UIActivityViewController(activityItems: [captureIMageFromUIview() ?? UIImage(named: "broken_image") as Any], applicationActivities: nil)
        controller.completionWithItemsHandler = { activity, completed, items, error in
            if(completed){
                print("share meme completed")
                self.save()
            } else{
              print("Sharing meme failed")
            }
            
        }
        present(controller, animated: true)
    }
    
    func save() {
        // Create the meme
        let meme = Meme(topText: imageTopTxt.text!, bottomText: imageBottomTxt.text!, originalImage: memeImage.image!)
    }
}
