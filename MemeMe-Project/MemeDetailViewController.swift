//
//  MemeDetailViewController.swift
//  MemeMe-Project
//
//  Created by TEJAKO3-Old Mac on 28/01/23.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    
    var chosenMeme: Meme.Meme!
  

    @IBOutlet weak var chosenMemeImageView: UIImageView!
    @IBOutlet weak var memeNotAvailable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(chosenMeme != nil){
            memeNotAvailable.isHidden = true
            chosenMemeImageView.isHidden = false
            chosenMemeImageView.image = chosenMeme.memedImage
        } else{
            memeNotAvailable.isHidden = false
            chosenMemeImageView.isHidden = true
        }
    }

}
