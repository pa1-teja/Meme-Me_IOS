//
//  SentMemesTabBarControllerViewController.swift
//  MemeMe-Project
//
//  Created by TEJAKO3-Old Mac on 29/01/23.
//

import UIKit

class SentMemesTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.title = "Sent Memes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(naviagateToMemeEditor))
    }
    
    @objc func naviagateToMemeEditor(){
        
        let memeEditViewController = storyboard?.instantiateViewController(withIdentifier: "MemeEditorView") as! CaptureImage
        
        present(memeEditViewController, animated: true)
    }
}
