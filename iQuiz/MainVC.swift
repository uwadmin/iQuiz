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
    var titleDesc: [[String]] = []
    var urlChanged = false
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


    @IBAction func deleteFile(_ sender: Any) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("data.json")
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch let error as NSError {
                print("Error: \(error.domain)")
            }
        }
    }

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
                if (qArr.count == 0) {
                    qArr = defaultQArr
                }
                if (titleDesc.count == 0) {
                    titleDesc = defaultTitleDesc
                }
                print("URL not correct and no local quizzes found", error)
            }
        }

        urlChanged = false
        
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
        self.present(svc!, animated: true) { }
    }

    func loadQuizzes() {
        let scienceImg = UIImage(named: "Science")
        let mathImg = UIImage(named: "Math")
        let marvelImg = UIImage(named: "Marvel")
//
//        guard let science = Quiz(name: "Science", photo: scienceImg, desc: "Questions about science") else {
//            fatalError("Unable to instantiate science")
//        }
//        guard let marvel = Quiz(name: "Marvel Super Heroes", photo: marvelImg, desc: "Questions about marvel super heroes") else {
//            fatalError("Unable to instantiate marvel")
//        }
//        guard let math = Quiz(name: "Mathematics", photo: mathImg, desc: "Questions about math") else {
//            fatalError("Unable to instantiate math")
//        }
        quizzes = []
        for ele in titleDesc {
            guard let quizCell = Quiz(name: ele[0], photo: scienceImg, desc: ele[1]) else {
                fatalError("Unable to instantiate \(ele[0])")
            }
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
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let qvc = storyboard?.instantiateViewController(withIdentifier: "qvc") as? QuestionVC
        qvc?.index = indexPath.row
        qvc?.urlStr = self.urlStr
        qvc?.qArr = self.qArr
        qvc?.titleDesc = self.titleDesc
        self.presentL(qvc!)
    }

    @objc func refresh(_ refreshControl: UIRefreshControl) {
        urlChanged = true
        loadData()
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
