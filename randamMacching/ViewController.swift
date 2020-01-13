//
//  ViewController.swift
//  randamMacching
//
//  Created by 福山帆士 on 2020/01/01.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import IBAnimatable

class ViewController: UIViewController,UITextFieldDelegate {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var textFirld: AnimatableTextField!
    let userDefault = UserDefaults.standard
    var txtActiveField = UITextField()
    @IBOutlet weak var stackView: AnimatableStackView!
    @IBOutlet weak var imageView: AnimatableImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.app.roomId = "0"
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapAction(_:))))
}
    
    @objc func imageTapAction(_ sender:UITapGestureRecognizer){
        self.view.endEditing(true)
    }

    @IBAction func loginActionButton(_ sender: Any) {
        
        let nameText = textFirld.text
        
        if nameText == ""{
            alertAction(name: "名前を入力してください")
            return
        }
        
        userDefault.set(nameText, forKey: "name")
        
    }
    
    func alertAction(name:String){
        let alertController = UIAlertController(title: "アラート", message: name, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController,animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    
    
    @objc func handleKeyboardWillShowNotification(notification: NSNotification){
        let userInfo = notification.userInfo
        let keybordScreenEndFrame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let keybordy = self.view.frame.size.height - keybordScreenEndFrame.height
        
        let stackLimit:CGFloat = self.stackView.frame.origin.y + 60
        
        if stackLimit >= keybordy - 60{
            UIView.animate(withDuration: 0.25,delay: 0.0,options:.curveEaseIn,animations:{
                self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (stackLimit - (keybordy - 60)), width: self.view.bounds.width, height:self.view.bounds.height)
            },completion: nil)
        }
    }
    @objc func handleKeyboardWillHideNotification(notification: NSNotification){
        UIView.animate(withDuration: 0.25,delay:0.0,options:.curveEaseIn,animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            },completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        textFirld.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHideNotification(notification:)),name:UIResponder.keyboardWillHideNotification,object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShowNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        if userDefault.string(forKey: "name") != nil{
            textFirld.text = userDefault.string(forKey: "name")
        }else{
            textFirld.text = String()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
}
