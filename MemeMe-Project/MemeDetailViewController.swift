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
            toggleOnScreenMemesVisibility(isMemeDataAvailable: true)
            chosenMemeImageView.image = chosenMeme.memedImage
        } else{
            toggleOnScreenMemesVisibility(isMemeDataAvailable: false)
        }
    }
    
    
    func toggleOnScreenMemesVisibility(isMemeDataAvailable: Bool){
        memeNotAvailable.isHidden = isMemeDataAvailable
        chosenMemeImageView.isHidden = !isMemeDataAvailable
    }

}
