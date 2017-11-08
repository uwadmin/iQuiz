//
//  QuizTableViewController.swift
//  iQuiz
//
//  Created by ​ on 11/5/17.
//  Copyright © 2017 iGuest. All rights reserved.
//

import UIKit

class QuizTableViewController: UITableViewController {
    
    var quizzes = [Quiz]()

    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        loadQuizzes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "QuizCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? QuizCell  else {
            fatalError("The dequeued cell is not an instance of QuizCell.")
        }
        
        cell.titleLabel.adjustsFontSizeToFitWidth=true
        cell.desLabel.adjustsFontSizeToFitWidth=true
        
        let quiz = quizzes[indexPath.row]
        
        cell.titleLabel.text = quiz.name
        cell.iconImage.image = quiz.photo
        cell.desLabel.text = quiz.desc
        return cell
    }
}
