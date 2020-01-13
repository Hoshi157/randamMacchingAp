//
//  animetionViewController.swift
//  randamMacching
//
//  Created by 福山帆士 on 2020/01/12.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit

class animetionViewController: UIViewController {
    
    var imageView:UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        self.view.backgroundColor = .magenta
        self.imageView.center = self.view.center
        self.imageView.image = UIImage(named: "c-icon")
        self.view.addSubview(self.imageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3,delay:1.0,options:.curveEaseIn,animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion: nil)
        UIView.animate(withDuration: 0.2, delay: 1.3, options: .curveEaseIn, animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 8.0, y: 8.0)
        }, completion: { (Bool) in
            self.imageView.removeFromSuperview()
            self.performSegue(withIdentifier:"segue", sender: nil)
        })
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
