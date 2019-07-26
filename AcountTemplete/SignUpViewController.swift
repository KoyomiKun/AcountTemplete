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
import SwiftyJSON
import Alamofire
import SCLAlertView
import RxCocoa
import RxSwift

class SignUpViewController: FormViewController{
    var countDownDisposable:Disposable!
    override func viewDidLoad() {
        super.viewDidLoad()
        rowKeyboardSpacing = 20
        navigationController?.navigationBar.topItem?.title = ""
        setForm()
    }
}
// set form
extension SignUpViewController{
    func setForm(){
        form +++ Section("")
            <<< TextRow("username"){
                row in
                row.title = "User name"
                }.cellSetup({
                    cell,row in
                    cell.titleLabel?.font = UIUtils.commonFont(size: 20)
                })
            <<< PasswordRow("password"){
                row in
                row.title = "Password"
                }.cellSetup({
                    cell,row in
                    cell.titleLabel?.font = UIUtils.commonFont(size: 20)
                })
            <<< PasswordRow("confirmPassword"){
                row in
                row.title = "Confirm Password"
                }.cellSetup({
                    cell,row in
                    cell.titleLabel?.font = UIUtils.commonFont(size: 20)
                })
            +++ Section("", {
                section in
                section.tag = "phoneInfo"
                section.hidden = Condition.function(["password","confirmPassword","username"], { form in
                    let password = (form.rowBy(tag: "password") as? PasswordRow)?.value
                    let confirmPassword = (form.rowBy(tag: "confirmPassword") as? PasswordRow)?.value
                    if password != confirmPassword || password == nil ||  (form.rowBy(tag: "username") as? TextRow)?.value == nil{
                        self.form.rowBy(tag: "confirm")?.baseCell.tintColor = Color.grey.lighten1
                        return true
                    }
                    self.form.rowBy(tag: "confirm")?.baseCell.tintColor = Color.blue.accent2
                    return false
                })
            })
            <<< SegmentedRow<String>("type").cellSetup({
                cell,row in
                row.options = ["family","common"]
                row.title = "Account type          "
                cell.titleLabel?.font = UIUtils.commonFont(size: 20)
            })
            <<< PhoneRow("phone"){
                row in
                row.title = "Phone number"
                }.cellSetup({
                    cell,row in
                    cell.titleLabel?.font = UIUtils.commonFont(size: 20)
                })
            <<< PhoneRow("code"){
                row in
                row.title = "Verification Code"
                }.cellSetup({
                    cell,row in
                    cell.titleLabel?.font = UIUtils.commonFont(size: 20)
                })
            <<< ButtonRow("sendMessage").cellSetup({
                cell,row in
                cell.textLabel?.font = UIUtils.commonFont(size: 20)
                cell.tintColor = Color.blue.accent2
                row.title = "Send message"
            }).onCellSelection({
                cell,row in
                let phone = (self.form.rowBy(tag: "phone") as? PhoneRow)?.value
                if phone != nil && cell.tintColor == Color.blue.accent2{
                    self.sendMessage(phone:phone!)
                }
            })
            +++ Section("")
            <<< ButtonRow("confirm").cellSetup({
                cell,row in
                cell.textLabel?.font = UIUtils.commonFont(size: 20)
                cell.tintColor = Color.grey.lighten1
                row.title = "Confirm"
            }).onCellSelection({
                cell,row  in
                if cell.tintColor == Color.grey.lighten1
                {}else{
                    self.confirmCode()
                }
            })
    }
    @objc func dismisskeyboard(){
        self.view.endEditing(true)
    }
    func register(){
        let type = (self.form.rowBy(tag: "type") as? SegmentedRow<String>)?.value
        var typeIsFamily = true
        switch type {
        case "family":
            typeIsFamily = true
        case "common":
            typeIsFamily = false
        default:
            let alert = SCLAlertView(appearance: UIUtils.appearance)
            alert.addButton("OK", action: {})
            alert.showWarning("Register Fail", subTitle: "Please choose an account type")
            return
        }
        let username = (self.form.rowBy(tag: "username") as? TextRow)?.value
        let password = (self.form.rowBy(tag: "password") as? PasswordRow)?.value
        let phonenumber = (self.form.rowBy(tag: "phone") as? PhoneRow)?.value
        let para:Parameters = ["password": password!,
                               "phone": phonenumber!,
                               "username": username!]
        NetworkUtils.postRequest(method: typeIsFamily ? "/account/family/register" : "/account/common/register" , parameters: para, header: nil).responseJSON(completionHandler: {
            response in
            let alert = SCLAlertView(appearance: UIUtils.appearance)
            if response.result.isSuccess{
                if let value = response.result.value {
                    let json = JSON(value)
                    if json["code"].int == 200 {
                        alert.addButton("OK", action: {
                            self.navigationController?.popViewController(animated: true)
                        })
                        alert.showSuccess("Rigister Success", subTitle: "Please Sign in")
                    }else{
                        alert.addButton("OK", action: {})
                        alert.showError("Rigister Fail", subTitle: json["message"].string!)
                    }
                }
            }else{
                alert.addButton("OK", action: {})
                alert.showError("Rigister Fail", subTitle: "Please check your network")
            }
        })
    }
    
    func confirmCode(){
        let phone = (self.form.rowBy(tag: "phone") as? PhoneRow)?.value
        let code = (self.form.rowBy(tag: "code") as? PhoneRow)?.value
        if code == nil {
            let alert = SCLAlertView(appearance: UIUtils.appearance)
            alert.addButton("OK", action: {
                (self.form.rowBy(tag: "code") as? PhoneRow)?.cell.textField.text = ""
            })
            alert.showError("Rigister Fail", subTitle: "Please check your verification code")
            return
        }
        SMSSDK.commitVerificationCode(code!, phoneNumber: phone!, zone: "86", result: {
            error in
            if error == nil{
                self.register()
            }else{
                let alert = SCLAlertView(appearance: UIUtils.appearance)
                alert.addButton("OK", action: {
                    (self.form.rowBy(tag: "code") as? PhoneRow)?.cell.textField.text = ""
                })
                alert.showError("Rigister Fail", subTitle: "Please check your verification code")
            }
        })
    }
    
    func sendMessage(phone:String){
        SMSSDK.getVerificationCode(by: .SMS, phoneNumber: phone, zone: "86", result: {
            error in
            if error == nil{
                let countDownSeconds = 30
                let button = (self.form.rowBy(tag: "sendMessage") as? ButtonRow)?.cell
                button?.tintColor = Color.grey.lighten1
                self.countDownDisposable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
                    .map { countDownSeconds - $0 }
                    .do(onNext: { second in
                        if second == 0 {
                            button?.tintColor = Color.blue.accent2
                            button?.textLabel?.text = "Send Message"
                            self.countDownDisposable.dispose()
                        }
                    })
                    .subscribe(onNext: { second in
                        button?.textLabel?.text = "\(second)s"
                    })
            }else{
                let alert = SCLAlertView(appearance: UIUtils.appearance)
                alert.addButton("OK", action: {
                    (self.form.rowBy(tag: "phone") as? PhoneRow)?.cell.textField.text = ""
                })
                alert.showError("Can't send message", subTitle: "Please check your phone number")

            }
            
        })
    }
}
