//
//  EventVC.swift
//  todolist
//
//  Created by HaoKai Lee on 2022/3/31.
//

import UIKit
import CoreData

class EventVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    

    @IBOutlet weak var switchSegement: UISegmentedControl!
    @IBOutlet weak var eventTF: UITextField!
    @IBOutlet weak var eventTBV: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var Event:[Event] = []
    var Finish:[Finish] = []
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.eventTBV.delegate = self
        self.eventTBV.dataSource = self
        self.eventTF.delegate = self

        self.Event = self.selectObject()
        self.Finish = self.selectDoneObject()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        eventTF.resignFirstResponder()
        return true
    }
    
    
    
    @IBAction func addEventBtn(_ sender: Any) {
        if eventTF.text == ""{
            let alert = UIAlertController.init(title: "請勿輸入空值", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            let event = NSEntityDescription.insertNewObject(forEntityName: "Event", into: self.context) as! Event
            event.title = eventTF.text
            do{
                try self.context.save()
            }catch{
                fatalError("存擋錯誤\(error)")
            }
            self.Event = self.selectObject()
            DispatchQueue.main.async {
                self.eventTBV.reloadData()
            }
        }
    }
    
    @IBAction func `switch`(_ sender: Any) {
        self.Event = self.selectObject()
        self.Finish = self.selectDoneObject()
        DispatchQueue.main.async {
            self.eventTBV.reloadData()
        }
    }
    
    func selectObject() -> Array<Event>{
        var Event:[Event] = []
        let request = NSFetchRequest<Event>(entityName: "Event")
        do{
            let results = try self.context.fetch(request)
            for result in results{
                Event.append(result)
            }
        }catch{
            fatalError("查訊錯誤\(error)")
        }
        return Event
    }
    
    func deleteObject(indexPath:IndexPath){
        let request = NSFetchRequest<Event>(entityName: "Event")
        do{
            let results = try self.context.fetch(request)
            for item in results{
                if item.title == self.Event[indexPath.row].title{
                    context.delete(item)
                    break
                }
            }
            try self.context.save()
        }catch{
            fatalError("刪除失敗\(error)")
        }
        let alert = UIAlertController.init(title: "已從待完成中刪除", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: {
            self.Event = self.selectObject()
            DispatchQueue.main.async {
                self.eventTBV.reloadData()
            }
        })
    }
    
    func deleteDoneObject(indexPath:IndexPath){
        let request = NSFetchRequest<Finish>(entityName: "Finish")
        do{
            let results = try self.context.fetch(request)
            for item in results{
                if item.title == self.Finish[indexPath.row].title{
                    context.delete(item)
                    break
                }
            }
            try self.context.save()
        }catch{
            fatalError("刪除失敗\(error)")
        }
        let alert = UIAlertController.init(title: "已從已完成中刪除", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: {
            self.Finish = self.selectDoneObject()
            DispatchQueue.main.async {
                self.eventTBV.reloadData()
            }
        })
    }
    
    func doneObject(indexPath:IndexPath){
        if switchSegement.selectedSegmentIndex == 1{
            
        }else{
            let done = NSEntityDescription.insertNewObject(forEntityName: "Finish", into: self.context) as! Finish
            let now = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            let nowtime = dateFormatter.string(from: now)
            
            done.title = self.Event[indexPath.row].title
            done.time = nowtime
            do{
                try self.context.save()
                
            }catch{
                fatalError("存擋錯誤\(error)")
            }
            self.Finish = selectDoneObject()
            
            deleteObject(indexPath: indexPath)
            DispatchQueue.main.async {
                self.eventTBV.reloadData()
            }
        }
    }
    
    func selectDoneObject() -> Array<Finish>{
        var Finish:[Finish] = []
        let request = NSFetchRequest<Finish>(entityName: "Finish")
        do{
            let results = try self.context.fetch(request)
            for result in results{
                Finish.append(result)
            }
        }catch{
            fatalError("查訊錯誤\(error)")
        }
        return Finish
    }
    
    func timePassing(indexPath:IndexPath){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let now = dateFormatter.date(from: Finish[indexPath.row].time!)
        let sinceNow = -Int((now?.timeIntervalSinceNow)!)
        if sinceNow < 86400{
            print(sinceNow)
            print(now)
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch switchSegement.selectedSegmentIndex {
        case 0:
            return Event.count
        case 1:
            return Finish.count
        default:
           break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        switch switchSegement.selectedSegmentIndex {
        case 0:
            cell.textLabel?.text = Event[indexPath.row].title
            cell.detailTextLabel?.text = ""
        case 1:
            cell.textLabel?.text = Finish[indexPath.row].title
            cell.detailTextLabel?.text = Finish[indexPath.row].time
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if switchSegement.selectedSegmentIndex == 1{
            let alert = UIAlertController.init(
                title: "編輯", message: "", preferredStyle: .alert
            )
            let deleteAction = UIAlertAction.init(title: "刪除", style: .default){
                _ in
                DispatchQueue.main.async {
                    self.deleteDoneObject(indexPath: indexPath)
                }
            }
            alert.addAction(deleteAction)
            self.present(alert, animated: true, completion: nil)
            
        }else{
            let alert = UIAlertController.init(
                title: "編輯", message: "", preferredStyle: .alert
            )
            let deleteAction = UIAlertAction.init(title: "刪除", style: .default){
                _ in
                DispatchQueue.main.async {
                    self.deleteObject(indexPath: indexPath)
                }
            }
            let doneAction = UIAlertAction.init(title: "已完成", style: .default){
                _ in
                DispatchQueue.main.async {
                    self.doneObject(indexPath: indexPath)
                    self.timePassing(indexPath: indexPath)
                }
            }
            
            alert.addAction(deleteAction)
            alert.addAction(doneAction)
            self.present(alert, animated: true, completion: nil)
        }
    }



}
