//
//  ViewController.swift
//  iQuiz
//
//  Created by ​ on 11/5/17.
//  Copyright © 2017 iGuest. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    var quizzes = [Quiz]()
    var titleArr: [String] = []
    var qArr: [[[String]]] = []
    var urlChanged = false
    var defaultQArr: [[[String]]] = [
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

    var urlStr = "https://tednewardsandbox.site44.com/questions.json"

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
            if (urlChanged) {
                fetch()
            } else {
                loadLocal()
            }
            return data
        }
        
        func fetch() {
            if (valid(urlStr)) {
                guard let url = URL(string: urlStr) else { fatalError("url not found") }
                do {
                    data = try Data(contentsOf: url)
                    save(data)
                } catch {
                    print("URL not found!", error)
                }
            }
        }
        
        func loadLocal() {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = dir.appendingPathComponent("data.json")
                do {
                    let text = try String(contentsOf: fileURL, encoding: .utf8)
                    data = text.data(using: .utf8)!
                    print("read file")
                } catch {
                    print(urlStr)
                    print("No such file")
                }
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

        let decoder = JSONDecoder()
        do {
            let allQuizzes = try decoder.decode([QuizJSON].self, from: readJson(urlStr))
            qArr = []
            for quiz in allQuizzes {
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
        if (qArr.count == 0) {
            qArr = defaultQArr
            print("no json found")
        }
        print("updated")
        print(qArr)
        urlChanged = false
    }

    func valid(_ urlString: String?) -> Bool {
        guard let urlString = urlString,
            let url = URL(string: urlString) else {
                return false
        }
        return UIApplication.shared.canOpenURL(url)
    }

    @IBAction func btnSettingsPressed(_ sender: UIBarButtonItem) {
        let svc = storyboard?.instantiateViewController(withIdentifier: "svc") as? SettingsVC
        svc?.modalPresentationStyle = .popover
        svc?.popoverPresentationController?.barButtonItem = sender
        svc?.urlStr = self.urlStr
        self.present(svc!, animated: true) { }
    }

    private func loadQuizzes() {
        let scienceImg = UIImage(named: "Science")
        let mathImg = UIImage(named: "Math")
        let marvelImg = UIImage(named: "Marvel")
        guard let science = Quiz(name: "Science", photo: scienceImg, desc: "Questions about science") else {
            fatalError("Unable to instantiate science")
        }
        guard let marvel = Quiz(name: "Marvel Super Heroes", photo: marvelImg, desc: "Questions about marvel super heroes") else {
            fatalError("Unable to instantiate marvel")
        }
        guard let math = Quiz(name: "Mathematics", photo: mathImg, desc: "Questions about math") else {
            fatalError("Unable to instantiate math")
        }
        quizzes += [science, marvel, math]
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
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let qvc = storyboard?.instantiateViewController(withIdentifier: "qvc") as? QuestionVC
        qvc?.index = indexPath.row
        qvc?.urlStr = self.urlStr
        qvc?.qArr = self.qArr
        qvc?.titleArr = self.titleArr
        self.presentL(qvc!)
    }

    @objc func refresh(_ refreshControl: UIRefreshControl) {
        urlChanged = true
        loadData()
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
        refreshControl.tintColor = self.view.tintColor
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
