//
//  AddTableTableViewController.swift
//  FoodPin
//
//  Created by liuhanzhi on 15/11/14.
//  Copyright © 2015年 AppCoda. All rights reserved.
//

import UIKit
import CoreData

class AddTableTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var nameTextField:UITextField!
    @IBOutlet weak var typeTextField:UITextField!
    @IBOutlet weak var locationTextField:UITextField!
    @IBOutlet weak var yesButton:UIButton!
    @IBOutlet weak var noButton:UIButton!
    
    var isBeenHere = false
    var restaurant:Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let alertController = UIAlertController(title: "Take Photo From", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            let photoAction = UIAlertAction(title: "相册", style: UIAlertActionStyle.Default, handler: {
                (action:UIAlertAction!) -> Void in
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .PhotoLibrary
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                    
                    imagePicker.delegate = self
                }
            })
            let cameraAction = UIAlertAction(title: "相机", style: .Default, handler: {
                (action:UIAlertAction!) -> Void in
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .Camera
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                    
                    imagePicker.delegate = self
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(photoAction)
            alertController.addAction(cameraAction)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //选取照片后的回调
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //选取照片回来后导航的颜色变了 可能ios系统bug
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        //navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor() //cancel的字体颜色显示异常  还是没法解决。
        //UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false) //新版本上ios status的颜色正常
    }
    
    @IBAction func saveAction() {
            var emptyMsg:String?
            if nameTextField.text == nil || nameTextField.text == "" {
                emptyMsg = "name"
            }else if typeTextField.text == nil || typeTextField.text == "" {
                emptyMsg = "type"
            }else if locationTextField.text == nil || locationTextField.text == ""  {
                emptyMsg = "location"
            }
           
            if emptyMsg != nil {
                let alertController:UIAlertController = UIAlertController(title: "Ops", message: "We can't proceed as you forget to fill in the restaurant \(emptyMsg!).All fields are mandatory.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                print("Name:\(nameTextField.text!)")
                print("Type:\(typeTextField.text!)")
                print("Location:\(locationTextField.text!)")
                print("Have you been here:" + (isBeenHere ? "yes": "no"))
                
                //保存到数据库
                let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
                
                restaurant = NSEntityDescription.insertNewObjectForEntityForName("Restaurant", inManagedObjectContext: managedObjectContext) as! Restaurant
                restaurant.name = nameTextField.text
                restaurant.type = typeTextField.text
                restaurant.location = locationTextField.text
                restaurant.image = UIImagePNGRepresentation(imageView.image!)
                restaurant.isVisited = isBeenHere
                
                do{
                    try managedObjectContext.save()
                }catch {
                    print("save data error!!!!!!!!!!")
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                }

                performSegueWithIdentifier("unwindToHomeScreen", sender: self)
            }
    }
    
    func saveToCoreData(restaurant:Restaurant){
        
    }
    
    @IBAction func yesAction(){
        isBeenHere = true
        yesButton.backgroundColor = UIColor.redColor()
        noButton.backgroundColor = UIColor.grayColor()
    }
    
    @IBAction func noAction(){
        isBeenHere = false
        yesButton.backgroundColor = UIColor.grayColor()
        noButton.backgroundColor = UIColor.redColor()
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
