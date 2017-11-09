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

    @IBAction func btnSettingsPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Settings go here", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    private func loadQuizzes() {
        let scienceImg = UIImage(named: "Science")
        let mathImg = UIImage(named: "Math")
        let marvelImg = UIImage(named: "Marvel")
        guard let science = Quiz(name: "Science", photo: scienceImg, desc: "Questions about science") else {
            fatalError("Unable to instantiate science")
        }
        guard let math = Quiz(name: "Mathematics", photo: mathImg, desc: "Questions about math") else {
            fatalError("Unable to instantiate math")
        }
        guard let marvel = Quiz(name: "Marvel Super Heroes", photo: marvelImg, desc: "Questions about marvel super heroes") else {
            fatalError("Unable to instantiate marvel")
        }
        quizzes += [science, math, marvel]
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
            fatalError("The dequeued cell is not an instance of QuizCell.")
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
        self.presentL(qvc!)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let indexPath = tableView.indexPathForSelectedRow {
//            let rowNum = indexPath.row
//            let destVC = segue.destination as! QuestionVC
//            destVC.index = rowNum
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadQuizzes()
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
