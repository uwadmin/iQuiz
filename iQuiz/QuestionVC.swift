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
    var qIndex: Int = 0
    var selectedAns: String = ""
    let path = Bundle.main.path(forResource: "data", ofType: "json")

    struct Quiz: Codable {
        var title: String
        var desc: String
        var questions: [Question]

        struct Question: Codable {
            let text: String
            let answer: String
            let answers: [String]
        }
    }

    var titleArr: [String] = []
    var qArr: [[[String]]] = [
        [["Electromagnetic radiation emitted from a nucleus is most likely to be in the form of",
          "gamma rays", "microwaves", "visible light", "ultraviolet radiation"],
         ["What is the limiting high-temperature molar heat capacity at constant volume of a gas-phase diatomic molecule?",
          "7/2 × R", "2R", "5/2 × R", "3R"],
         ["Which of the following techniques could be used to demonstrate protein binding to specific DNA sequences?",
          "Western blot hybridization", "Northern blot hybridization", "Southern blot hybridization", "Polymerase chain reaction"]],
        [["J. Jonah Jameson spent a lot of money to defeat that wall-crawler. Just after the death of Gwen Stacy, who did JJJ pay to take him out?",
          "Luke Cage", "Doctor Octopus", "Scorpion", "Taskmaster"],
         ["In a plot twist nobody cared about, the Masked Maurader was revealed to be:",
          "Daredevil's landlord", "Peter Parker's roommate", "The Fantastic Four's mailman", "The X-Men's housekeeper"],
         ["An off-hand comment by Stan Lee caused Iron Man to receive what odd addition to his armor?",
          "Iron Nose", "Iron Toes", "Iron Fingernails", "Iron Nipples"]],
        [["A tree is a connected graph with no cycles. How many nonisomorphic trees with 5 vertices exist?",
          "3", "4", "5", "6"],
         ["(1 + i)¹⁰ = ",
          "32i", "32", "32(i + 1)", "1"],
         ["What is the volume of the solid in xyz-space bounded by the surfaces y = x² , y = 2 - x² , z = 0, and z = y + 3?",
          "32/3", "16/3", "104/105", "208/105"]]
    ]

    func loadData() {
        
        func readJson(_ urlStr: String) -> Data {
            var data = Data()
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = dir.appendingPathComponent("data.json")
                do {
                    let text = try String(contentsOf: fileURL, encoding: .utf8)
                    data = text.data(using: .utf8)!
                    print("read file")
                } catch {
                    print(error)
                }
            } else {
                guard let url = URL(string: urlStr) else { fatalError("url not found") }
                do {
                    data = try Data(contentsOf: url)
                    save(data)
                } catch {
                    print("URL not found!", error)
                }
            }
            return data
        }

        func save(_ content: Data) {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = dir.appendingPathComponent("data.json")
                guard let JSONString = String(data: content, encoding: String.Encoding.utf8) else {
                    return
                }
                do {
                    print(JSONString)
                    try JSONString.write(to: fileURL, atomically: false, encoding: .utf8)
                    print("wrote file")
                }
                catch {
                    print(error)
                }
            }
        }

        let urlStr = "https://cdn.rawgit.com/uwadmin/b583231b7dfa52dcdd00bc847bd57ea5/raw/3ce9d4dad4813d4231a6003cdc9c1037609409c7/data.json"

        let decoder = JSONDecoder()
        do {
            let quizzes = try decoder.decode([Quiz].self, from: readJson(urlStr))
            for quiz in quizzes {
                titleArr.append(quiz.title)
                var catArr: [[String]] = []

                for question in quiz.questions {
                    var questArr: [String] = []
                    questArr.append(question.text)
                    for answer in question.answers {
                        questArr.append(answer)
                    }
                    questArr.swapAt(1, Int(question.answer)!)
                    catArr.append(questArr)
                }
                qArr.append(catArr)
            }
        } catch {
            print("URL not correct and no local quizzes found", error)
        }
    }

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
            avc?.totalNum = self.qArr[index].count
            avc?.correct = self.correct
            avc?.correctAns = self.qArr[index][qRand[qIndex]][1]
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
        if (selectedAns == qArr[index][qRand[qIndex]][1]) {
            correct = false
            correctNum -= 1
        }
        sender.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        sender.isEnabled = false
        submitBtn.isEnabled = true
        submitBtn.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        for item in answerBtns! {
            item.isEnabled = true
        }
    }

    @IBAction func answerPressed(_ sender: UIButton) {
        sender.isSelected = true
        selectedAns = sender.title(for: .normal)!
        correct = false
        selected = true
        for item in answerBtns! {
            if item.tag != sender.tag {
                item.isSelected = false
            }
            if item.isSelected {
                item.backgroundColor = self.view.tintColor
                item.setTitleColor(.white, for: .normal)
                item.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
            } else {
                item.backgroundColor = .white
                item.setTitleColor(self.view.tintColor, for: .normal)
                item.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
            }
        }
    }

    @IBAction func submitPressed(_ sender: UIButton) {
        if (selected) {
            submited = true
            sender.isEnabled = false
            sender.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
            redoBtn.isEnabled = true
            redoBtn.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
            if (selectedAns == qArr[index][qRand[qIndex]][1]) {
                correct = true
                correctNum += 1
            }
            for item in answerBtns! {
                item.isEnabled = false
            }
        } else {
            let alert = UIAlertController(title: "No answer selected!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        if (qRand.count == 0) {
            qRand = Array(0...qArr[index].count - 1).shuffled()
        }
        load(qIndex)
        toolbarTitle.text = toolbarTitle.text! + " (\(qIndex + 1)/\(qArr[index].count))"
        for button in buttons! {
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            button.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
            button.layer.shadowOpacity = 0.5
            button.layer.shadowRadius = 0.0
            button.layer.masksToBounds = false
            button.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.lineBreakMode = .byClipping
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.minimumScaleFactor = 0.1
            button.titleLabel?.baselineAdjustment = .alignCenters
        }
    }

    func load(_ qIndex: Int) {
        switch index {
        case 0: toolbarTitle.text = "Science"
        case 1: toolbarTitle.text = "Marvel Super Heroes"
        case 2: toolbarTitle.text = "Mathematics"
        default: break }
        question.text = qArr[index][qRand[qIndex]][0]
        let answers = qArr[index][qRand[qIndex]]
        a.setTitle(answers[aRand[0]], for: .normal)
        b.setTitle(answers[aRand[1]], for: .normal)
        c.setTitle(answers[aRand[2]], for: .normal)
        d.setTitle(answers[aRand[3]], for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
