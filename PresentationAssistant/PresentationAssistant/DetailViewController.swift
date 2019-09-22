//
//  DetailViewController.swift
//  PresentationAssistant
//
//  Created by Bowen Li on 2018/5/7.
//  Copyright © 2018年 Bowen Li. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var timeView: UILabel!
    @IBOutlet weak var wordsView: UITableView!
    
    //var deleteTopic = false
    
    var fileName = ""
    var estiamtedTime = 0.0
    var cells:[String] = []
    var cellTime:[String] = []
    var titleList:[Topic] = []
    var detailList:[Detail] = []
    var wordField: UITextField?
    var timeField: UITextField?
    var index = -1
    //var topic:Topic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleView.text = "Presentation: " + fileName
        self.searchTopic()
        timeView.text = "Estimated Time: " + String(Int(estiamtedTime/60)) + " minutes"
        self.searchDetail()
        wordsView.delegate = self
        wordsView.dataSource = self
        self.wordsView.reloadData()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func searchTopic(){
        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        let context = container.viewContext
        let request: NSFetchRequest<Topic> = Topic.fetchRequest()
        
        request.predicate = NSPredicate(format: "title == %@", fileName)
        request.sortDescriptors = [NSSortDescriptor(key: "estimatedTime", ascending: true)]
        let result = try? context.fetch(request)
        for data in result!{
            //print(data.value(forKey: "title"))
            titleList.append(data)
            estiamtedTime = data.value(forKey: "estimatedTime") as! Double
        }
        
    }
    
    func creatAlert (title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: self.yesHandler)
        alert.addAction(yesAction)
        self.present(alert, animated: true)
    }

    func yesHandler(alert: UIAlertAction!){
        print("Delete Topic")
        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        let context = container.viewContext
        context.delete(titleList[0])
        do{
            try context.save()
        } catch {
            print("Failed saving")
        }
        performSegue(withIdentifier: "back", sender: self)
        
    }
    
    func searchDetail(){
        print("Search Detail:")
        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        let context = container.viewContext
        let request: NSFetchRequest<Detail> = Detail.fetchRequest()
        
        request.predicate = NSPredicate(format: "table.title == %@", fileName)
        request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        let result = try? context.fetch(request)
        /*for data in result!{
            words.append(data.value(forKey: "word") as! String)
            times.append(data.value(forKey: "time") as! Double)
        }*/
        detailList = result!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = wordsView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = detailList[indexPath.row].word
        cell?.detailTextLabel?.text = String(detailList[indexPath.row].time) + " min"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        index = indexPath.row
        if editingStyle == .delete{
            deleteData()
        }
        
        tableView.reloadData()
    }
    
    
    @IBAction func deleteTopic(_ sender: Any) {
        creatAlert(title: "WARNING!", message: "Do you want to delete this topic?")
    }
    @IBAction func backBtn(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: self)
    }
    
    
    @IBAction func addNewWord(_ sender: Any) {
        wordAlert(title: "New Words", message: "Input new words and time.")
        self.wordsView.reloadData()
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
        else if let number = timeField?.text, let num = Double(number){
            
            if index != -1{
                deleteData()
            }
            saveData(word: (wordField?.text)!, time: num)
            
            index = -1
            self.wordsView.reloadData()
            
        }
        else
        {
            index = -1
            let alert1 = UIAlertController(title: "Input Error", message: "Time only accept number.", preferredStyle: .alert)
            alert1.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert1, animated: true)
        }
        
    }
    
    func deleteData(){
        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        let context = container.viewContext
        if detailList != []{
            let deletion = detailList[index]
            context.delete(deletion)
            do{
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
        searchDetail()
    }
    
    func saveData(word: String, time: Double){
        print("Save Data")
        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        let context = container.viewContext
        let newDetail = NSEntityDescription.entity(forEntityName: "Detail", in: context)
        let new = NSManagedObject(entity: newDetail!, insertInto: context)
        new.setValue(word, forKey: "word")
        new.setValue(time, forKey: "time")
        new.setValue(titleList[0], forKey: "table")
        do{
            try context.save()
        } catch {
            print("Failed saving")
        }
        searchDetail()
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        wordAlert(title: "Modify", message: "Change the values")
        tableView.reloadData()
        
    }
}
