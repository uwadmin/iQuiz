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
    var titleDesc: [[String]] = []
    var correct: Bool = false
    var correctAns = ""
    var correctNum: Int = 0
    var urlStr = ""
    var scoreArr:[String] = []


    @IBAction func exitToMain(_ sender: Any) {
        let mvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mvc") as! MainVC
        mvc.urlStr = self.urlStr
        mvc.qArr = self.qArr
        mvc.titleDesc = self.titleDesc
        mvc.scoreArr = self.scoreArr
        self.presentR(mvc)
    }

    @IBAction func goToNext(_ sender: Any) {
        if (qIndex + 1 == totalNum) {
            let fvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "fvc") as! FinishedVC
            fvc.correctNum = self.correctNum
            fvc.totalNum = self.totalNum
            fvc.urlStr = self.urlStr
            fvc.qArr = self.qArr
            fvc.titleDesc = self.titleDesc
            fvc.index = self.index
            fvc.scoreArr = self.scoreArr
            self.presentL(fvc)
        } else {
            let qvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "qvc") as! QuestionVC
//            let qvc = presentingViewController as? QuestionVC
            qvc.index = self.index
            qvc.qIndex = self.qIndex + 1
            qvc.correctNum = self.correctNum
            qvc.qRand = self.qRand
            qvc.urlStr = self.urlStr
            qvc.titleDesc = self.titleDesc
            qvc.qArr = self.qArr
            qvc.scoreArr = self.scoreArr
            self.presentL(qvc)
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
