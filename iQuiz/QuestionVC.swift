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
    var qIndex:Int = 0
    var selectedAns:String = ""
    
    let qDict: [[[String]]] = [
        [["Electromagnetic radiation emitted from a nucleus is most likely to be in the form of",
          "gamma rays", "microwaves", "visible light", "ultraviolet radiation"],
         ["What is the limiting high-temperature molar heat capacity at constant volume of a gas-phase diatomic molecule?",
          "7/2 × R", "2R", "5/2 × R", "3R"],
         ["Which of the following techniques could be used to demonstrate protein binding to specific DNA sequences?",
          "Western blot hybridization", "Northern blot hybridization", "Southern blot hybridization", "Polymerase chain reaction"]],
        [["A tree is a connected graph with no cycles. How many nonisomorphic trees with 5 vertices exist?",
          "3", "4", "5", "6"],
         ["(1 + i)¹⁰ = ",
          "32i", "32", "32(i + 1)", "1"],
         ["What is the volume of the solid in xyz-space bounded by the surfaces y = x² , y = 2 - x² , z = 0, and z = y + 3?",
          "32/3", "16/3", "104/105", "208/105"]],
        [["J. Jonah Jameson spent a lot of money to defeat that wall-crawler. Just after the death of Gwen Stacy, who did JJJ pay to take him out?",
          "Luke Cage", "Doctor Octopus", "Scorpion", "Taskmaster"],
         ["In a plot twist nobody cared about, the Masked Maurader was revealed to be:",
          "Daredevil's landlord", "Peter Parker's roommate", "The Fantastic Four's mailman", "The X-Men's housekeeper"],
         ["An off-hand comment by Stan Lee caused Iron Man to receive what odd addition to his armor?",
          "Iron Nose", "Iron Toes", "Iron Fingernails", "Iron Nipples"]]
    ]
    
    var aRand: [Int] = [1, 2, 3, 4].shuffled()
    var qRand: [Int] = []
    
    @IBAction func exitToMain(_ sender: Any) {
        let mvc = storyboard?.instantiateViewController(withIdentifier: "mvc") as? MainVC
        self.presentR(mvc!)
    }
    
    @IBAction func goToNext(_ sender: Any) {
        if (submited) {
            submited = false
            selected = false
            let avc = storyboard?.instantiateViewController(withIdentifier: "avc") as? AnswerVC
            avc?.index = self.index
            avc?.qIndex = self.qIndex
            avc?.totalNum = self.qDict[index].count
            avc?.correct = self.correct
            avc?.correctAns = self.qDict[index][qRand[qIndex]][1]
            avc?.correctNum = self.correctNum
            avc?.qRand = self.qRand
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
            if (selectedAns == qDict[index][qRand[qIndex]][1]) {
                correct = true
                correctNum += 1
            }
        } else {
            let alert = UIAlertController(title: "No answer selected!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (qRand.count == 0) {
            qRand = Array(0...qDict[index].count - 1).shuffled()
        }
        load(qIndex)
        toolbarTitle.text = toolbarTitle.text! + " (\(qIndex + 1)/\(qDict[index].count))"
        for button in buttons! {
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.lineBreakMode = .byClipping
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.minimumScaleFactor = 0.1
            button.titleLabel?.baselineAdjustment = .alignCenters
            }
    }
    
    func load(_ qIndex:Int) {
        switch index {
        case 0: toolbarTitle.text = "Science"
        case 1: toolbarTitle.text = "Mathematics"
        case 2: toolbarTitle.text = "Marvel Super Heroes"
        default: break }
        question.text = qDict[index][qRand[qIndex]][0]
        let answers = qDict[index][qRand[qIndex]]
        a.setTitle(answers[aRand[0]], for: .normal)
        b.setTitle(answers[aRand[1]], for: .normal)
        c.setTitle(answers[aRand[2]], for: .normal)
        d.setTitle(answers[aRand[3]], for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
