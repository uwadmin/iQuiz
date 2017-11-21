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
        input.text = "https://cdn.rawgit.com/uwadmin/c3b4021fa726c8ac7a318a0901901730/raw/2be68cc1e49cf6f12305536e84e44308fddad5d6/test.json"
    }

    @IBAction func ted(_ sender: Any) {
        input.text = "https://tednewardsandbox.site44.com/questions.json"
    }

    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
