//
//  ViewController.swift
//  iQuiz
//
//  Created by ​ on 11/5/17.
//  Copyright © 2017 iGuest. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!

    var quizzes = [Quiz]()
    var titleDesc: [[String]] = []
    var urlChanged = false
    var scoreArr: [String] = []
    var urlStr = "https://tednewardsandbox.site44.com/questions.json"
    var qArr: [[[String]]] = []
    var defaultTitleDesc: [[String]] = [["Science!", "Because SCIENCE!"], ["Marvel Super Heroes", "Avengers, Assemble!"], ["Mathematics", "Did you pass the third grade?"]]
    var defaultQArr: [[[String]]] = [
        [
            ["What is fire?", "One of the four classical elements", "A magical reaction given to us by God", "A band that hasn\'t yet been discovered", "Fire! Fire! Fire! heh-heh"]
        ],
        [
            ["Who is Iron Man?", "Tony Stark", "Obadiah Stane", "A rock hit by Megadeth", "Nobody knows"],
            ["Who founded the X-Men?", "Professor X", "Tony Stark", "The X-Institute", "Erik Lensherr"],
            ["How did Spider-Man get his powers?", "He was bitten by a radioactive spider", "He ate a radioactive spider", "He is a radioactive spider", "He looked at a radioactive spider"]
        ],
        [
            ["What is 2+2?", "4", "22", "An irrational number", "Nobody knows"]
        ]
    ]

    struct QuizJSON: Codable {
        var title: String
        var desc: String
        var questions: [Question]

        struct Question: Codable {
            let text: String
            let answer: String
            let answers: [String]
        }
    }

    func loadData() {
        var data = Data()

        func readJson(_ urlStr: String) -> Data {
            urlChanged ? fetch() : loadLocal()
            return data
        }

        func loadLocal() {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = dir.appendingPathComponent("data.json")
                do {
                    let text = try String(contentsOf: fileURL, encoding: .utf8)
                    data = text.data(using: .utf8)!
                    print("read file")
                } catch {
                    if (qArr.count == 0) {
                        qArr = defaultQArr
                    }
                    if (titleDesc.count == 0) {
                        titleDesc = defaultTitleDesc
                    }
                    print("No such file")
                }
            }
        }

        func resetScores() {
            scoreArr = []
            for _ in titleDesc {
                scoreArr.append("No Score")
            }
        }

        if (qArr.count == 0 || urlChanged) {
            let decoder = JSONDecoder()
            do {
                let allQuizzes = try decoder.decode([QuizJSON].self, from: readJson(urlStr))
                qArr = []
                titleDesc = []
                for quiz in allQuizzes {
                    var catArr: [[String]] = []
                    var titleArr: [String] = [quiz.title, quiz.desc]
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
                    titleDesc.append(titleArr)
                }
            } catch {
                loadLocal()
                print("URL not correct", error)
            }
            resetScores()
        }

        urlChanged = false

        func fetch() {
            guard let url = URL(string: urlStr) else { fatalError("url not found") }
            do {
                data = try Data(contentsOf: url)
                save(data)
                saveURL()
            } catch {
                print("URL not found!", error)
            }
        }

        func save(_ content: Data) {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = dir.appendingPathComponent("data.json")
                guard let JSONString = String(data: content, encoding: String.Encoding.utf8) else {
                    return
                }
                do {
                    try JSONString.write(to: fileURL, atomically: false, encoding: .utf8)
                    print("wrote file")
                }
                catch {
                    print(error)
                }
            }
        }

        func saveURL() {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = dir.appendingPathComponent("url.txt")
                do {
                    try urlStr.write(to: fileURL, atomically: false, encoding: .utf8)
                    print("wrote URL")
                } catch {
                    print(error)
                }
            }
        }
    }

    @IBAction func btnSettingsPressed(_ sender: UIBarButtonItem) {
        let svc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "svc") as! SettingsVC
        svc.modalPresentationStyle = .popover
        if let pop = svc.popoverPresentationController {
            pop.barButtonItem = sender
            pop.delegate = self
        }
        self.present(svc, animated: true) { }
    }

    @IBAction func btnScoresPressed(_ sender: UIBarButtonItem) {
        let score = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "score") as! ScoreVC
        score.modalPresentationStyle = .popover
        score.scoreArr = self.scoreArr
        score.titleDesc = self.titleDesc
        if let pop = score.popoverPresentationController {
            pop.barButtonItem = sender
            pop.delegate = self
        }
        self.present(score, animated: true) { }
    }

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }

    func loadQuizzes() {
        let scienceImg = UIImage(named: "Science")
        let mathImg = UIImage(named: "Math")
        let marvelImg = UIImage(named: "Marvel")
        var iconImage = UIImage(named: "info")
        quizzes = []
        var index = 0
        for ele in titleDesc {
            switch ele[0] {
            case "Science!": iconImage = scienceImg!
            case "Marvel Super Heroes": iconImage = marvelImg!
            case "Mathematics": iconImage = mathImg!
            default: break
            }
            guard let quizCell = Quiz(name: ele[0], photo: iconImage, desc: ele[1], score: scoreArr[index].components(separatedBy: " ").first!) else {
                fatalError("Unable to instantiate \(ele[0])")
            }
            index += 1
            quizzes += [quizCell]
        }
//        quizzes += [science, marvel, math]
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "QuizCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? QuizCell else {
            fatalError("The de-queued cell is not an instance of QuizCell.")
        }

        cell.titleLabel.adjustsFontSizeToFitWidth = true
        cell.desLabel.adjustsFontSizeToFitWidth = true

        let quiz = quizzes[indexPath.row]
        cell.titleLabel.text = quiz.name
        cell.iconImage.image = quiz.photo
        cell.desLabel.text = quiz.desc
        cell.score.text = quiz.score

        if cell.score.text == "No" {
            cell.score.isHidden = true
        } else {
            cell.score.isHidden = false
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let qvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "qvc") as! QuestionVC
        qvc.index = indexPath.row
        qvc.urlStr = self.urlStr
        qvc.qArr = self.qArr
        qvc.scoreArr = self.scoreArr
        qvc.titleDesc = self.titleDesc
        self.presentL(qvc)
    }

    @objc func refresh(_ refreshControl: UIRefreshControl) {
        var storedURL = ""
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("url.txt")
            do {
                storedURL = try String(contentsOf: fileURL, encoding: .utf8)
            } catch {
                storedURL = urlStr
            }
        }
        if (urlStr == storedURL) {
            urlChanged = true
            print("changed")
        }
        loadData()
        loadQuizzes()
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            refreshControl.endRefreshing()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        loadQuizzes()
        tableView.dataSource = self
        tableView.delegate = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Update Quiz Data...")
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
