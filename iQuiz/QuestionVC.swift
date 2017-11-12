//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by ​ on 11/8/17.
//  Copyright © 2017 iGuest. All rights reserved.
//

import UIKit

class QuestionVC: UIViewController {
    @IBOutlet weak var toolbarTitle: UILabel!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var redoBtn: UIButton!
    @IBOutlet weak var a: UIButton!
    @IBOutlet weak var b: UIButton!
    @IBOutlet weak var c: UIButton!
    @IBOutlet weak var d: UIButton!
    @IBOutlet var answerBtns: Array<UIButton>?
    @IBOutlet var buttons: Array<UIButton>?

    
    var selected: Bool = false
    var submited: Bool = false
    var correct: Bool = false
    var correctNum: Int = 0
    var index: Int = -1
    var qNum:Int = 0
    var selectedAns:String = ""
    
    
    @IBAction func exitToMain(_ sender: Any) {
        let mvc = storyboard?.instantiateViewController(withIdentifier: "mvc") as? MainVC
        self.presentR(mvc!)
    }
    
    @IBAction func goToNext(_ sender: Any) {
        if (qNum == qDict[index].count - 1) {
            let fvc = storyboard?.instantiateViewController(withIdentifier: "fvc") as? FinishedVC
            fvc?.correctNum = self.correctNum
            fvc?.totalNum = self.qDict[index].count
            self.presentL(fvc!)
        } else if (submited) {
            submited = false
            selected = false
            let avc = storyboard?.instantiateViewController(withIdentifier: "avc") as? AnswerVC
            avc?.index = self.index
            avc?.qNum = self.qNum
            avc?.correct = self.correct
            avc?.correctAns = self.qDict[index][qNum][1]
            avc?.correctNum = self.correctNum
            self.presentL(avc!)
        } else {
            let alert = UIAlertController(title: "Please select an answer and submit first!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func redoPressed(_ sender: UIButton) {
        submited = false
        redoBtn.isEnabled = false
        submitBtn.isEnabled = true
    }
    
    @IBAction func answerPressed(_ sender: UIButton) {
        sender.isSelected = true
        correct = false
        selectedAns = sender.title(for: .normal)!
        selected = true
        for item in answerBtns! {
            if item.tag != sender.tag {
                item.isSelected = false
            }
            if item.isSelected {
                item.backgroundColor = self.view.tintColor
                item.setTitleColor(.white, for: .normal)
            } else {
                item.backgroundColor = .white
                item.setTitleColor(self.view.tintColor, for: .normal)
            }
        }
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        if (selected) {
            submited = true
            sender.isEnabled = false
            redoBtn.isEnabled = true
            if (selectedAns == qDict[index][qNum][1]) {
                correct = true
                correctNum += 1
            }
        } else {
            let alert = UIAlertController(title: "No answer selected!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    let p = [1, 2, 3, 4].shuffled()
    
    let qDict: [[[String]]] = [
        [["test a very very long line of the question, test a very very long line of the question test a very very long line of the question", "test a very very long line of the question, test a very very long line of the question test a very very long line of the question", "A2", "A3", "A4"], ["SQ2", "A1", "A2", "A3", "A4"], ["SQ3", "A1", "A2", "A3", "A4"]],
        [["MQ1", "A1", "A2", "A3", "A4"], ["MQ2", "A1", "A2", "A3", "A4"], ["MQ3", "A1", "A2", "A3", "A4"]],
        [["HQ1", "A1", "A2", "A3", "A4"], ["HQ2", "A1", "A2", "A3", "A4"], ["HQ3", "A1", "A2", "A3", "A4"]]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load(qNum)
        toolbarTitle.text = toolbarTitle.text! + " (\(qNum + 1)/\(qDict[index].count))"
        for button in buttons! {
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.lineBreakMode = .byClipping
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.minimumScaleFactor = 0.1
            button.titleLabel?.baselineAdjustment = .alignCenters
        }
    }
    
    func load(_ qNum:Int) {
        switch index {
        case 0: toolbarTitle.text = "Science"
        case 1: toolbarTitle.text = "Mathematics"
        case 2: toolbarTitle.text = "Marvel Super Heroes"
        default: break }
        question.text = qDict[index][qNum][0]
        let answers = qDict[index][qNum]
        a.setTitle(answers[p[0]], for: .normal)
        b.setTitle(answers[p[1]], for: .normal)
        c.setTitle(answers[p[2]], for: .normal)
        d.setTitle(answers[p[3]], for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
