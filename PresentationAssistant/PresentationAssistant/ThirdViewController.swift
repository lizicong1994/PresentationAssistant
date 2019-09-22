//
//  ThirdViewController.swift
//  PresentationAssistant
//
//  Created by Bowen Li on 2018/4/26.
//  Copyright © 2018年 Bowen Li. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    

    @IBOutlet weak var titleShow: UILabel!
    @IBOutlet weak var timeShow: UILabel!
    @IBOutlet weak var newWordsShow: UILabel!

    @IBOutlet weak var wordsShow: UITableView!
    
    var wordField: UITextField?
    var timeField: UITextField?
    var titlename = ""
    var estimatedTime = 0.0
    var cells: [String] = []
    var cellTime: [String] = []
    var detailList: [Detail] = []
    //var detail:Detail?
    var index = -1
    
    override func viewDidLoad() {
        
        wordsShow.delegate = self
        wordsShow.dataSource = self
        titleShow.text = "Presentation: " + titlename;
        timeShow.text = "Estimated Time: " + String(Int(estimatedTime/60)) + " minutes";
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func addNewWord(_ sender: Any) {
        wordAlert(title: "New Words", message: "Input new words and time.")
        
    }
    
    func wordAlert (title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField(configurationHandler: wordField)
        alert.addTextField(configurationHandler: timeField)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: self.okHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: self.cancelHandler)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
        
    }
    func cancelHandler(alert: UIAlertAction!){
        index = -1
    }
    func wordField(textField: UITextField!) -> Void {
        wordField = textField
        wordField?.keyboardType = UIKeyboardType.default
        wordField?.placeholder = "Words"
    }
    func timeField(textField: UITextField) -> Void {
        timeField = textField
        timeField?.keyboardType = UIKeyboardType.decimalPad
        textField.placeholder = "Time in minutes"
    }
    func okHandler(alert: UIAlertAction!){
        
        if(wordField?.text?.isEmpty)! || (timeField?.text?.isEmpty)!{
            index = -1
            let alert1 = UIAlertController(title: "Input Error", message: "Input can't be empty.", preferredStyle: .alert)
            alert1.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert1, animated: true)
        }
        else if let number = timeField?.text, let _ = Double(number){
            if index != -1{
                cells.remove(at: index)
                cellTime.remove(at: index)
            }
            newWordsShow.text = wordField?.text
            cells.append((wordField?.text!)!)
            cellTime.append((timeField?.text)!)
            index = -1
            self.wordsShow.reloadData()
            
        }
        else
        {
            index = -1
            let alert1 = UIAlertController(title: "Input Error", message: "Time only accept number.", preferredStyle: .alert)
            alert1.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert1, animated: true)
        }
        
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = wordsShow.dequeueReusableCell(withIdentifier: "wordsCell")
        cell?.textLabel?.text = cells[indexPath.row]
        cell?.detailTextLabel?.text = cellTime[indexPath.row] + " min"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            cells.remove(at: indexPath.row)
            cellTime.remove(at: indexPath.row)
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        wordAlert(title: "Modify", message: "Change the values")

        tableView.reloadData()
        
    }

    @IBAction func saveData(_ sender: UIButton) {
        performSegue(withIdentifier: "saveContext", sender: self)
    }
    
    func creatAlert (title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as? FourthViewController
        destination?.fileName = titlename
        destination?.totalTime = estimatedTime
        destination?.words = cells
        destination?.times = cellTime
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
