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
    @IBOutlet weak var toolbarTitle: UILabel!
    
    var index: Int = -1
    var qIndex: Int = -1
    var totalNum: Int = -1
    var qRand: [Int] = []
    var qArr: [[[String]]] = []
    var correct: Bool = false
    var correctAns = ""
    var correctNum: Int = 0
    var urlStr = ""


    @IBAction func exitToMain(_ sender: Any) {
        let mvc = storyboard?.instantiateViewController(withIdentifier: "mvc") as? MainVC
        mvc?.urlStr = self.urlStr
        self.presentR(mvc!)
    }

    @IBAction func goToNext(_ sender: Any) {
        if (qIndex + 1 == totalNum) {
            let fvc = storyboard?.instantiateViewController(withIdentifier: "fvc") as? FinishedVC
            fvc?.correctNum = self.correctNum
            fvc?.totalNum = self.totalNum
            fvc?.urlStr = self.urlStr
            fvc?.qArr = self.qArr
            self.presentL(fvc!)
        } else {
            let qvc = storyboard?.instantiateViewController(withIdentifier: "qvc") as? QuestionVC
            qvc?.index = self.index
            qvc?.qIndex = self.qIndex + 1
            qvc?.correctNum = self.correctNum
            qvc?.qRand = self.qRand
            qvc?.urlStr = self.urlStr
            self.presentL(qvc!)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarTitle.text = toolbarTitle.text! + " (\(qIndex + 1)/\(totalNum))"
        answer.text = correctAns
        answer.layer.borderWidth = 2
        answer.layer.cornerRadius = 5
        
        if (correct) {
            result.text = "You got it correct! It is:"
            indicator.image = #imageLiteral(resourceName:"right")
            answer.layer.borderColor = UIColor.green.cgColor
        } else {
            result.text = "You got it wrong! The right answer is:"
            indicator.image = #imageLiteral(resourceName:"wrong")
            answer.layer.borderColor = UIColor.red.cgColor
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
