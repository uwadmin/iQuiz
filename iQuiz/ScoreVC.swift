//
//  ScoreVC.swift
//  iQuiz
//
//  Created by ​ on 11/20/17.
//  Copyright © 2017 iGuest. All rights reserved.
//

import UIKit

class ScoreVC: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    var scoreArr:[String] = []
    var titleDesc:[[String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        var index = 0
        label.text = ""
        for ele in titleDesc {
            label.text = label.text! + ele[0] + ": " + scoreArr[index] + "\n"
            index += 1
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
