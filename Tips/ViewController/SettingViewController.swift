//
//  SettingViewController.swift
//  Tips
//
//  Created by Ngoc Do on 2/21/16.
//  Copyright © 2016 com.appable. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - OUTLET
    
    @IBOutlet weak var txtDefault: UITextField!
    
    @IBOutlet weak var txtCustom1: UITextField!
    
    @IBOutlet weak var txtCustom2: UITextField!
    
    @IBOutlet weak var txtPerson: UITextField!
    
    @IBOutlet weak var viewPercent: UIView!
    
    
    @IBOutlet weak var viewPerson: UIView!
    //MARK: - Action
    
    @IBAction func btnBack(sender: AnyObject) {
        self.view.endEditing(true)
        //list percent
        getListPercentInscrease()
        //get list Viewcontroller
        let controllers:[UIViewController] = (self.navigationController?.viewControllers)!
        
        for controller in controllers{
            if(controller as UIViewController).isKindOfClass(HomeViewController){
                //set percent for segment
                (controller as! HomeViewController).setCustomSetting()
            }
        }
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    
    
    //MARK: - view function
    override func viewDidLoad() {
        super.viewDidLoad()

        setDefaultSeting()
        registerTextfieldDelegate()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDefaultSeting(){
        txtDefault.text = "\(listPercent[0])"// 0 is always default percent
        txtCustom1.text = "\(listPercent[1])"
        txtCustom2.text = "\(listPercent[2])"
        txtPerson.text = personAmount
    }
    

    func getListPercentInscrease(){
        listPercent.removeAll(keepCapacity: false)
        listPercent.append(Int(txtDefault.text!)!)
        listPercent.append(Int(txtCustom1.text!)!)
        listPercent.append(Int(txtCustom2.text!)!)
        
        userDefault.setObject(listPercent, forKey: "listPercent")
        userDefault.setObject(txtPerson.text, forKey: "personAmount")
        userDefault.synchronize()
        
    }
    
    //MARK:- Textfield function
    func registerTextfieldDelegate(){
        txtDefault.delegate = self
        txtCustom1.delegate = self
        txtCustom2.delegate = self
        txtPerson.delegate = self
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(range.location > 2){
            textField.text = String(textField.text!.characters.dropLast())
        }
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if( textField.text == ""){
            textField.text = "0"
        }
    }
    
    //MARK: - close keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}
