//
//  FourthViewController.swift
//  PresentationAssistant
//
//  Created by Bowen Li on 2018/5/3.
//  Copyright © 2018年 Bowen Li. All rights reserved.
//

import UIKit
import CoreData

class FourthViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var estimatedTime: UILabel!
    @IBOutlet weak var wordsView: UITableView!
    
    
    
    var fileName = ""
    var totalTime = 0.0
    var words: [String] = []
    var times: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        let context = container.viewContext
        
        let entityOne = NSEntityDescription.entity(forEntityName: "Topic", in: context)
        let newTopic = NSManagedObject(entity: entityOne!, insertInto: context)
        let newDetail = NSEntityDescription.entity(forEntityName: "Detail", in: context)
        
        for (word, time) in zip(words, times){
            
            let new = NSManagedObject(entity: newDetail!, insertInto: context)
            new.setValue(word, forKey: "word")
            new.setValue(Double(time), forKey: "time")
            new.setValue(newTopic, forKey: "table")
        }
 
        newTopic.setValue(fileName, forKey: "title")
        newTopic.setValue(totalTime, forKey: "estimatedTime")
        do{
            try context.save()
        } catch {
            print("Failed saving")
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Topic")
        request.returnsObjectsAsFaults = false
        
        do{
            let result = try context.fetch(request)
            print("Data in Core Data")
            for data in result as! [NSManagedObject]{
                print(data.value(forKey: "title") as! String)
            }
        } catch {
            print("Failed")
        }
        
        
        wordsView.delegate = self
        wordsView.dataSource = self
        titleName.text = "Presentation: " + fileName;
        estimatedTime.text = "Estimated Time: " + String(Int(totalTime/60)) + " minutes";
        //words.append(String(totalTime))
        let rootFile = "title"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        let rootURL = DocumentDirURL.appendingPathComponent(rootFile).appendingPathExtension("txt")
        do{
            var titles = try String(contentsOf: rootURL,encoding:.utf8)
            titles.append(fileName)
            print(titles)
        }
        catch{}
        
        //print(fileURL)
        //let text = String(totalTime) + "//" + context
        do{
            try String(totalTime).write(to: fileURL, atomically: false, encoding: String.Encoding.utf8)
        }
        catch {
            print("error")
        }
        (words as NSArray).write(to: fileURL, atomically: true)
        do{
            let savedData = try String(contentsOf: fileURL, encoding: .utf8)
            print(savedData)
        }
        catch{
            print("error")
        }
        
        //print(savedData)
        
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = wordsView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = words[indexPath.row]
        return cell!
    }

}
