//
//  SignUpViewController.swift
//  AcountTemplete
//
//  Created by Wallance on 2019/7/20.
//  Copyright © 2019 Wallance. All rights reserved.
//

import UIKit
import Eureka
import SnapKit
import Material
class SignUpViewController: FormViewController {
    let transController = TransitionController()
    
    var backButton:IconButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        rowKeyboardSpacing = 20
        
        form +++ Section("")
            <<< TextRow(){
                row in
                row.title = "User name"
                }.cellSetup({
                    cell,row in
                    cell.titleLabel?.font = UIUtils.commonFont(size: 20)
                })
            <<< PasswordRow(){
                row in
                row.title = "Password"
                }.cellSetup({
                    cell,row in
                    cell.titleLabel?.font = UIUtils.commonFont(size: 20)
                })
            <<< PasswordRow(){
                row in
                row.title = "Confirm Password"
                }.cellSetup({
                    cell,row in
                    cell.titleLabel?.font = UIUtils.commonFont(size: 20)
                })
            +++ Section("")
            <<< SegmentedRow<String>().cellSetup({
                cell,row in
                row.options = ["family","common"]
                row.title = "Account type          "
                cell.titleLabel?.font = UIUtils.commonFont(size: 20)
            })
            <<< PhoneRow(){
                row in
                row.title = "Phone number"
                }.cellSetup({
                    cell,row in
                    cell.titleLabel?.font = UIUtils.commonFont(size: 20)
                })
            <<< PhoneRow(){
                row in
                row.title = "Verification Code"
                }.cellSetup({
                    cell,row in
                    cell.titleLabel?.font = UIUtils.commonFont(size: 20)
                })
            <<< ButtonRow().cellSetup({
                cell,row in
                cell.textLabel?.font = UIUtils.commonFont(size: 20)
                row.title = "Send message"
            })
            <<< ButtonRow().cellSetup({
                cell,row in
                cell.textLabel?.font = UIUtils.commonFont(size: 20)
                row.title = "Confirm"
            })
        
        
//        let sendMessageButton = FlatButton(title: "Send Message",titleColor: Color.blue.accent2)
//        sendMessageButton.titleLabel?.font = UIUtils.commonFont(size: 20)
//        view.addSubview(sendMessageButton)
//        sendMessageButton.snp.makeConstraints({
//            make in
//            make.right.equalToSuperview()
//            make.left.equalTo(view.snp.centerX).offset(20)
//            make.top.equalTo(278)
//        })
//
//        let confirmButton = FlatButton(title: "Confirm",titleColor: Color.white)
//        confirmButton.titleLabel?.font = UIUtils.commonFont(size: 20)
//        view.addSubview(confirmButton)
//        confirmButton.backgroundColor = Color.blue.accent2
//        confirmButton.layer.cornerRadius = 20
//        confirmButton.snp.makeConstraints({
//            make in
//            make.centerX.equalToSuperview()
//            make.bottom.equalTo(view.snp.bottom).offset(-250)
//            make.width.equalTo(350)
//        })
        backButton = IconButton(image: Icon.cm.arrowBack)
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
