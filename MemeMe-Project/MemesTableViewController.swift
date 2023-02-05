//
//  MemesTableViewController.swift
//  MemeMe-Project
//
//  Created by TEJAKO3-Old Mac on 26/01/23.
//

import Foundation
import UIKit


class MemesTableViewController: UITableViewController{
    
    var memes: [Meme.Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    @IBOutlet weak var emptyMessage: UILabel!
    

    
    override func viewDidLoad() {
        navigationController?.toolbar.isHidden = false
    
        if(memes.isEmpty){
            toggleMemesEmptyMsgVisibility(isMemeDataAvailable: false)
        } else{
            toggleMemesEmptyMsgVisibility(isMemeDataAvailable: true)
        }
    }
 
    override func viewWillAppear(_ animated: Bool) {
        if(!memes.isEmpty){
            toggleMemesEmptyMsgVisibility(isMemeDataAvailable: true)
            refreshMemeDataOnTableView()
        }
    }
    
    func refreshMemeDataOnTableView(){
        tableView.reloadData()
    }
    
    func toggleMemesEmptyMsgVisibility(isMemeDataAvailable: Bool){
        emptyMessage.isHidden = isMemeDataAvailable
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let individualMemeCell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell")!
        let meme = memes[(indexPath as NSIndexPath).row]
        
        individualMemeCell.imageView?.image = meme.memedImage
        individualMemeCell.textLabel?.text = meme.topText + " .... " + meme.bottomText
        
        return individualMemeCell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let memeDetailController = storyboard?.instantiateViewController(withIdentifier: "ChosenMemeDetail") as! MemeDetailViewController
        
        memeDetailController.chosenMeme = memes[(indexPath as NSIndexPath).row]
        
        navigationController?.pushViewController(memeDetailController, animated: true)
        
    }
    
}
