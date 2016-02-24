//
//  ViewController.swift
//  Tips
//
//  Created by Ngoc Do on 2/21/16.
//  Copyright © 2016 com.appable. All rights reserved.
//

import UIKit
import Spring

class HomeViewController: UIViewController,UITextFieldDelegate {
    
    //MARK: - CONSTRAINT
    
    @IBOutlet weak var bottomTotalBill: NSLayoutConstraint!
    
    
    @IBOutlet weak var trailingViewTotalBill: NSLayoutConstraint!
    
    @IBOutlet weak var heightOfTotalBill: NSLayoutConstraint!
    

    @IBOutlet weak var trailingTipTwo: NSLayoutConstraint!
    @IBOutlet weak var trailingTipThree: NSLayoutConstraint!
    @IBOutlet weak var trailingTipCustom: NSLayoutConstraint!
    
    
    
    //MARK: - OUTLET
    
    
    @IBOutlet weak var lblTotal: UILabel!
    
    
    @IBOutlet weak var txtTotalBill: UITextField!
    
    @IBOutlet weak var segmentPercent: UISegmentedControl!
    
    @IBOutlet weak var lblTipAmount: SpringLabel!
    
    @IBOutlet weak var lblTipOne: SpringLabel!
    
    @IBOutlet weak var lblTipTwo: SpringLabel!
    
    @IBOutlet weak var lblTipThree: SpringLabel!
    
    @IBOutlet weak var lblTipCustom: SpringLabel!
    
    @IBOutlet weak var lblCustomNumber: SpringLabel!
    
    @IBOutlet weak var viewOne: UIView!
    

    @IBOutlet weak var viewTwo: SpringView!
    
    @IBOutlet weak var viewThree: SpringView!
    
    @IBOutlet weak var viewCustom: SpringView!
    
    //MARK: - ACTION
    
    @IBAction func textfieldChanged(sender: AnyObject) {
        if( txtTotalBill.text != "" ){
            let percentStr = segmentPercent.titleForSegmentAtIndex(segmentPercent.selectedSegmentIndex)
            let percent:Int = Int(removeSpecialCharsFromString(percentStr!))!
            let totalBill = (removeSpecialCharsFromString(txtTotalBill.text!) as NSString).doubleValue
            let tip = totalBill * Double(percent) / 100.0
            lblTipAmount.text = String(format: "$%.2f", tip)
            
            let totalForOne:Double = totalBill + tip
            lblTipOne.text = String(format: "$%.2f", totalForOne)
            
            let totalForTwo:Double = (totalBill + tip)/2.0
            lblTipTwo.text = String(format: "$%.2f", totalForTwo)
            
            let totalForThree:Double = (totalBill + tip)/3
            lblTipThree.text = String(format: "$%.2f", totalForThree)
            
            let customeNumber:Double = (removeSpecialCharsFromString(lblCustomNumber.text!) as NSString).doubleValue
            let totalForCustom:Double = (totalBill + tip) / customeNumber
            lblTipCustom.text = String(format: "$%.2f", totalForCustom)
        }else{
            lblTipAmount.text = "$0.00"
            lblTipOne.text = "$0.00"
        }
    }
    
    
    @IBAction func touchToEdit(sender: AnyObject) {
        
        if(self.bottomTotalBill.constant < self.heightOfTotalBill.constant) {
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.bottomTotalBill.constant += self.heightOfTotalBill.constant
                self.lblTotal.transform = CGAffineTransformScale(self.lblTotal.transform, 1.0, 0.75)
                self.trailingViewTotalBill.constant = defaultDistance
                self.view.layoutIfNeeded()
                
                
                }, completion: nil)
        }
    }
    
    let charSet = NSCharacterSet(charactersInString: "0123456789.").invertedSet
    var distanceViewResult:CGFloat!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //set the view bottom the textfild with height = 0
        txtTotalBill.delegate = self
    }
    var fristtime = true
    
    override func viewWillAppear(animated: Bool) {
        if(fristtime){
            //fristtime = false
            hideViewExtend()
            setCustomSetting()
            self.trailingViewTotalBill.constant = width - defaultDistance
            
        }
       
    }
    override func viewDidAppear(animated: Bool) {
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.viewOne.alpha = 0.5//animation go first, because animate by spring auto set alpha = 0
            self.setTotalBillIfExist()
            if(self.fristtime){
                self.fristtime = false
                self.txtTotalBill.becomeFirstResponder()
                self.touchToEdit(self.txtTotalBill)
            }
        }
    }

    
    //MARK: - Animation
    
    func setDefaultLableTotal(){
         if(self.bottomTotalBill.constant > self.heightOfTotalBill.constant) {
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.bottomTotalBill.constant -= self.heightOfTotalBill.constant
                
                self.lblTotal.transform = CGAffineTransformScale(self.lblTotal.transform, 1.0, 1.25)
                self.trailingViewTotalBill.constant = width - defaultDistance
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    func hideViewExtend(){
        viewTwo.alpha = 0.0
        viewThree.alpha = 0.0
        viewCustom.alpha = 0.0
        lblTipTwo.alpha = 0.0
        lblTipThree.alpha = 0.0
        lblTipCustom.alpha = 0.0
        
    }
    func showViewExtend(){

        self.view.layoutIfNeeded()
        animateView(viewTwo, delayDuration: 0.0)
        animateView(viewThree, delayDuration: 0.3)
        animateView(viewCustom, delayDuration: 0.6)
        self.viewTwo.alpha = 0.5
        self.viewThree.alpha = 0.5
        self.viewCustom.alpha = 0.5
        self.viewOne.alpha = 0.5
        
        animateLabel(lblTipTwo, delayDuration: 0.8)
        animateLabel(lblTipThree, delayDuration: 1.0)
        animateLabel(lblTipCustom, delayDuration: 1.2)
        
    }
    
    //MARK: - close keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        if(txtTotalBill.text == ""){
            setDefaultLableTotal()
        }
    }
    
    //MARK: - Textfield Function
    
    func textFieldDidBeginEditing(textField: UITextField) {
        hideViewExtend()
        if(txtTotalBill.text != ""){
            let cleaned = removeSpecialCharsFromString(txtTotalBill.text!)
            txtTotalBill.text = cleaned
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if(txtTotalBill.text != ""){
            txtTotalBill.text = String(format: "$%.2f", (txtTotalBill.text! as NSString).doubleValue)
            userDefault.setObject(txtTotalBill.text, forKey: "totalBill")
            
            showViewExtend()
            
        }
    }
    
    func removeSpecialCharsFromString(str: String) -> String {
        struct Constants {
            static let validChars = Set("0123456789.".characters)
        }
        return String(str.characters.filter { Constants.validChars.contains($0) })
    }
    
    //MARK: - SET CUSTOM SETTING
    func setCustomSetting(){
        if(userDefault.objectForKey("listPercent") != nil){
            listPercent = userDefault.objectForKey("listPercent") as! [Int]
        }
        if(userDefault.objectForKey("personAmount") != nil){
            personAmount = userDefault.objectForKey("personAmount") as! String
        }
        
        //get value of default.
        let defaultPercent:Int = listPercent[0]
        var listPercentForSorted:[Int] = listPercent
        listPercentForSorted.sortInPlace {
            return $0 < $1
        }
        for(var i:Int = 0; i < listPercentForSorted.count; i++) {
            self.segmentPercent.setTitle("\(listPercentForSorted[i])%", forSegmentAtIndex: i)
            
            if(listPercentForSorted[i] == defaultPercent){
                segmentPercent.selectedSegmentIndex = i
            }
        }
        //set person amout
        self.lblCustomNumber.text = "\(personAmount) x"
        self.textfieldChanged(txtTotalBill)
    }
    
    func setTotalBillIfExist(){
        if(userDefault.objectForKey("totalBill") != nil){
            let total:String = userDefault.objectForKey("totalBill") as! String
            txtTotalBill.text = total
            textfieldChanged(txtTotalBill)
        }
    }
    
    func animateView(springView:SpringView, delayDuration:CGFloat){
        springView.animation = "squeezeUp"
        springView.duration = standardDuration
        springView.delay = delayDuration
        springView.velocity = 0.5
        springView.damping = 0.8
        springView.animate()
    }
    
    func animateLabel(springLabel:SpringLabel, delayDuration:CGFloat){
        springLabel.animation = "zoomIn"
        springLabel.curve = "easeOut"
        springLabel.duration = standardDuration
        springLabel.delay = delayDuration
        springLabel.repeatCount = 2
        springLabel.animate()
    }
    
    


}

