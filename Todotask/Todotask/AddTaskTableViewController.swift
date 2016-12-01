//
//  AddTaskTableViewController.swift
//  Todotask
//
//  Created by Tools Team India on 20/11/16.
//  Copyright © 2016 Schneider-Electric. All rights reserved.
//

import UIKit
import UserNotifications

class AddTaskTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var notifiyDatePIcker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setMinimumDate()
        
        subjectTextField.delegate = self
        descriptionTextView.delegate = self
        createButton.layer.cornerRadius = 5
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddTaskTableViewController.hideKeyboard))
        tapGesture.numberOfTapsRequired = 1
        self.tableView.addGestureRecognizer(tapGesture)
    }

    func hideKeyboard()
    {
        self.view.endEditing(true)
    }
    
    func setMinimumDate()
    {
        self.notifiyDatePIcker.minimumDate = Date()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    @IBAction func notifyDatePickerChanged(_ sender: Any) {
        
    }

    @IBAction func createButtonClicked(_ sender: Any) {
        
        
        let dateComparisionResult:ComparisonResult = notifiyDatePIcker.date.compare(NSDate() as Date)
        
        if dateComparisionResult == ComparisonResult.orderedSame || subjectTextField.text?.characters.count == 0 || descriptionTextView.text.characters.count == 0
        {
            let alertController = UIAlertController(title: ":( :( :(", message: "Please fill subject, description", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alertController.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        else
        {
            var taskInfoDictionary = Dictionary<String,AnyObject>()
            taskInfoDictionary["createDate"] = NSDate()
            taskInfoDictionary["notifyDate"] = notifiyDatePIcker.date as AnyObject?
            taskInfoDictionary["taskDescription"] = descriptionTextView.text as AnyObject?
            taskInfoDictionary["taskSubject"] = subjectTextField.text as AnyObject?
            
            scheduleLocal()
            Todotask.createTodotaskWithInfo(taskInfoDictionary as NSDictionary, inManagedObjectContext: DataManager.sharedInstance.managedObjectContext!)
            
            do {
                try DataManager.sharedInstance.managedObjectContext?.save()
            }
            catch _ {
                
            }
            
            let alertController = UIAlertController(title: ":) :) :)", message: "Created New Task", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
             let _ = self.navigationController?.popViewController(animated: true)
            }))
            
            self.present(alertController, animated: true, completion: nil)
            
            
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        subjectTextField.resignFirstResponder()
        descriptionTextView.becomeFirstResponder()
        return true
    }
    
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        descriptionTextView.resignFirstResponder()
        return true
    }
    
    
    func scheduleLocal() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = subjectTextField.text!
        content.body = descriptionTextView.text!
        content.categoryIdentifier = "Sugeetha"
        content.sound = UNNotificationSound.default()
        
     
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: notifiyDatePIcker.date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
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
