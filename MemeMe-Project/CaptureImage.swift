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
        

        #if targetEnvironment(simulator)
        cameraBtn.isEnabled = false
        #else
        cameraBtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        #endif
      
        
        if(memeImage.image == nil){
            setMemeImageScreen(memeImageView: memeImage, image: nil, alertLabel: pickImageAlertLabel, isAlertLabelHidden: false, shareBtn: shareBtn, isSHareBtnEnabled: false)
        }
        
        
        setupTextField(textField: imageTopTxt, text: "top", isHidden: true, txtColor: UIColor.white, txtAlignment: .center, txtAttributes: memTxtAttributes)
        
        setupTextField(textField: imageBottomTxt, text: "Bottom", isHidden: true, txtColor: UIColor.white, txtAlignment: .center, txtAttributes: memTxtAttributes)
    }
    
    func setMemeImageScreen(memeImageView: UIImageView, image:UIImage?, alertLabel: UILabel, isAlertLabelHidden: Bool, shareBtn: UIBarButtonItem, isSHareBtnEnabled: Bool){
        memeImageView.image = image
        alertLabel.isHidden = isAlertLabelHidden
        shareBtn.isEnabled = isSHareBtnEnabled
    }
    
    func setupTextField(textField: UITextField, text: String, isHidden: Bool, txtColor: UIColor, txtAlignment: NSTextAlignment, txtAttributes: [NSAttributedString.Key: Any]) {
        textField.isHidden = isHidden
        textField.text = text.uppercased()
        textField.defaultTextAttributes = txtAttributes
        textField.textColor = txtColor
        textField.textAlignment = txtAlignment
        textField.delegate = txtFieldDelegate
      }
    
    func resetTextField(textField: UITextField, text: String, isHidden: Bool){
        textField.text = text.uppercased()
        textField.isHidden = isHidden
    }
    
    @IBAction func cancelAndReset(){
        resetTextField(textField: imageTopTxt, text: "top", isHidden: true)
        resetTextField(textField: imageBottomTxt, text: "bottom", isHidden: true)
        setMemeImageScreen(memeImageView: memeImage, image: nil, alertLabel: pickImageAlertLabel, isAlertLabelHidden: false, shareBtn: shareBtn, isSHareBtnEnabled: false)
    }
    
    @IBAction func pickAnImageFromGallery(){
        setupAndFireImagePickerController(sourceType: .savedPhotosAlbum)
    }
    
    func setupAndFireImagePickerController(sourceType: UIImagePickerController.SourceType){
        let uiImagePickerController = UIImagePickerController()
        uiImagePickerController.delegate = self
        uiImagePickerController.sourceType = sourceType
        uiImagePickerController.mediaTypes = ["public.image"]
        present(uiImagePickerController, animated: true)
    }
    
    @IBAction func pickImageFromCamera(){
        setupAndFireImagePickerController(sourceType: .camera)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage != nil){
            setAndAllowMemeCreation(pickedImage: info[UIImagePickerController.InfoKey.originalImage] as! UIImage)
            dismiss(animated: true)
        }
    }
    
    func setAndAllowMemeCreation(pickedImage: UIImage){
        setMemeImageScreen(memeImageView: memeImage, image: pickedImage, alertLabel: pickImageAlertLabel, isAlertLabelHidden: true, shareBtn: shareBtn, isSHareBtnEnabled: true)
        resetTextField(textField: imageTopTxt, text: "top", isHidden: false)
        resetTextField(textField: imageBottomTxt, text: "bottom", isHidden: false)
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        if(imageBottomTxt.isFirstResponder){
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
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
        let meme = Meme.Meme(topText: imageTopTxt.text!, bottomText: imageBottomTxt.text!, originalImage: memeImage.image!, memedImage: (captureIMageFromUIview() ?? UIImage(named: "broken_image"))!)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        dismiss(animated: true)
    }
}
