//
//  SettingsVC.swift
//  iQuiz
//
//  Created by ​ on 11/14/17.
//  Copyright © 2017 iGuest. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var input: UITextField!
    @IBOutlet var buttons: [UIButton]!
    
    var urlStr = ""
    
    @IBAction func deleteFile(_ sender: Any) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("data.json")
            let urlURL = dir.appendingPathComponent("url.txt")
            do {
                try FileManager.default.removeItem(at: fileURL)
                try FileManager.default.removeItem(at: urlURL)
            } catch let error as NSError {
                print("Error: \(error.domain)")
            }
        }
    }

    @IBAction func github(_ sender: Any) {
        input.text = "https://cdn.rawgit.com/uwadmin/1a1f0d906ee87fee477310c95ebd2683/raw/5ea55fc05ecbe661e147ebb21c16b016e8b7930f/long.json"
    }

    @IBAction func ted(_ sender: Any) {
        input.text = "https://tednewardsandbox.site44.com/questions.json"
    }

    @IBAction func updateURL(_ sender: UIButton) {
        if (valid(input.text)) {
            let mvc = self.presentingViewController as! MainVC
            mvc.urlStr = self.input.text!
            mvc.urlChanged = true
            mvc.loadData()
            mvc.loadQuizzes()
            mvc.tableView.reloadData()
            let alert = UIAlertController(title: "URL Updated!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Not a valid HTTPS URL", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func valid(_ urlString: String?) -> Bool {
        guard let urlString = urlString, let url = URL(string: urlString) else { return false }
        if !UIApplication.shared.canOpenURL(url) { return false }
        let regEx = "^https://[^\\s/$.?#].[^\\s]*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [regEx])
        return predicate.evaluate(with: urlString)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        for button in buttons {
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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
