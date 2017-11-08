//
//  ViewController.swift
//  iQuiz
//
//  Created by ​ on 11/5/17.
//  Copyright © 2017 iGuest. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBAction func btnSettingsPressed(_ sender: Any) {
            let alert = UIAlertController(title: "Settings go here", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
