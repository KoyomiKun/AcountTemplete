//
//  forgetPasswordViewController.swift
//  AcountTemplete
//
//  Created by Wallance on 2019/7/24.
//  Copyright © 2019 Wallance. All rights reserved.
//

import UIKit
import Material
import Eureka
import SCLAlertView
import RxCocoa
import RxSwift
import Alamofire
import SwiftyJSON

class forgetPasswordViewController: FormViewController {
    var countDownDisposable:Disposable!
    override func viewDidLoad() {
        super.viewDidLoad()
        rowKeyboardSpacing = 20
        navigationController?.navigationBar.topItem?.title = ""
        form +++ Section("")
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
            <<< ButtonRow("confirm").cellSetup({
                cell,row in
                cell.textLabel?.font = UIUtils.commonFont(size: 20)
                cell.tintColor = Color.blue.accent2
                row.title = "Confirm"
            }).onCellSelection({
                cell,row  in
                self.confirmCode()
            })
    }
    func confirmCode(){
        let phone = (self.form.rowBy(tag: "phone") as? PhoneRow)?.value
        let code = (self.form.rowBy(tag: "code") as? PhoneRow)?.value
        if code == nil {
            return
        }
        SMSSDK.commitVerificationCode(code!, phoneNumber: phone!, zone: "86", result: {
            error in
            if error == nil{
                let phone = (self.form.rowBy(tag: "phone") as? PhoneRow)?.value
                let resetView = ResetPasswordViewController()
                resetView.phone = phone
                self.navigationController?.pushViewController(resetView, animated: true)
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
                            button?.textLabel?.tintColor = Color.blue.accent2
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
class ResetPasswordViewController:FormViewController{
    
    public var phone:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section()
            <<< PasswordRow("password"){
                row in
                row.title = "New Password"
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
                }).cellUpdate({
                    cell,row in
                    let password = (self.form.rowBy(tag: "password") as? PasswordRow)?.value
                    if password != nil && password == cell.textField.text{
                        (self.form.rowBy(tag: "confirm") as? ButtonRow)?.cell.tintColor = Color.blue.accent2
                    }
                })
            <<< ButtonRow("confirm").cellSetup({
                cell,row in
                cell.textLabel?.font = UIUtils.commonFont(size: 20)
                cell.tintColor = Color.grey.lighten1
                row.title = "Confirm"
            }).onCellSelection({
                cell,row  in
                if cell.tintColor == Color.grey.lighten1
                {}else{
                    self.changePassword()
                }
            })
    }
    func changePassword(){
        let password = (self.form.rowBy(tag: "password") as? PasswordRow)?.value
        let para:Parameters = ["password": password!,"phoneNumber":phone!]
        NetworkUtils.postRequest(method: "/account/retrievePassword", parameters: para, header: nil).responseJSON(completionHandler: {
            response in
            let alert = SCLAlertView(appearance: UIUtils.appearance)
            if response.result.isSuccess{
                if let value = response.result.value{
                    let json = JSON(value)
                    if json["code"].int == 200{
                        alert.addButton("OK", action: {
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                        alert.showSuccess("Retrieve Success", subTitle: "Please sign in")
                    }else{
                        alert.addButton("OK", action: {
                        })
                        alert.showError("Retrieve Fail", subTitle: json["message"].string!)
                    }
                }
            }else{
                alert.addButton("OK", action: {
                })
                alert.showError("Retrieve Fail", subTitle: "Please check your network")
            }
        })
    }
}
