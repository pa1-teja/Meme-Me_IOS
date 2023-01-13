//
//  TopNBottomTxtFieldsDelegate.swift
//  MemeMe-Project
//
//  Created by TEJAKO3-Old Mac on 05/01/23.
//

import Foundation
import UIKit

class TopNBottomTxtFieldsDelegates: NSObject, UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
