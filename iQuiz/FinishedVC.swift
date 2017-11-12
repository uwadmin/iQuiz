//
//  FinishedVC.swift
//  iQuiz
//
//  Created by ​ on 11/11/17.
//  Copyright © 2017 iGuest. All rights reserved.
//

import UIKit

class FinishedVC: UIViewController {
    
    @IBOutlet weak var indicator: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var grade: UILabel!
    var correctNum:Int = 0
    var totalNum:Int = 0

    @IBAction func exitToMain(_ sender: Any) {
        let mvc = storyboard?.instantiateViewController(withIdentifier: "mvc") as? MainVC
        presentR(mvc!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ratio:Double = Double(correctNum) / Double(totalNum)
        let percent:String = (100 * ratio).rounded(toPlaces: 1).clean
        grade.text = "\(correctNum)/\(totalNum) = \(percent)%"
        if (ratio == 1) {
            label.text = "Amazing! "
            indicator.image = #imageLiteral(resourceName: "amazing")
            grade.textColor = .green
        } else if (ratio > 0.6) {
            label.text = "Good! "
            indicator.image = #imageLiteral(resourceName: "good")
            grade.textColor = self.view.tintColor
        } else {
            label.text = "You need to practice more! "
            indicator.image = #imageLiteral(resourceName: "practice")
            grade.textColor = .red
        }
        label.text = label.text! + "You got \(correctNum) out of \(totalNum) right!"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
