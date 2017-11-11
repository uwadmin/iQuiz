//
//  AnswerVC.swift
//  iQuiz
//
//  Created by ​ on 11/10/17.
//  Copyright © 2017 iGuest. All rights reserved.
//

import UIKit

class AnswerVC: UIViewController {
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var indicator: UIImageView!
    @IBOutlet weak var answer: UILabel!

    var index: Int = -1
    var qNum: Int = -1
    var correct: Bool = false
    var correctAns = ""
    var correctNum: Int = 0


    @IBAction func backBtnPressed(_ sender: UIButton) {
        let mvc = storyboard?.instantiateViewController(withIdentifier: "mvc") as? MainVC
        self.presentR(mvc!)
    }

    @IBAction func nextBtnPressed(_ sender: Any) {
        let qvc = storyboard?.instantiateViewController(withIdentifier: "qvc") as? QuestionVC
        qvc?.index = self.index
        qvc?.qNum = self.qNum + 1
        qvc?.correctNum = self.correctNum
        self.presentL(qvc!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        answer.text = correctAns
        if (correct) {
            result.text = "You got it correct! It is:"
            indicator.image = #imageLiteral(resourceName:"right")
        } else {
            result.text = "You got it wrong! The right answer is:"
            indicator.image = #imageLiteral(resourceName:"wrong")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
