//
//  ViewController.swift
//  AcountTemplete
//
//  Created by Wallance on 2019/7/19.
//  Copyright © 2019 Wallance. All rights reserved.
//

import UIKit
import SnapKit
import TextFieldEffects
import Material
import Alamofire
import SwiftyJSON
import SwiftyUserDefaults
import SCLAlertView
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    let userNameTextField = UIUtils.createTextField(withIdentify: "Phone Number",UIUtils.commonFont(size: 24))
    let passwordTextField = UIUtils.createTextField(withIdentify: "Password",UIUtils.commonFont(size: 24))
    
    var changePhoneNumber:Disposable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set gesture for keyboard dismissing
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismisskeyboard))
        self.view.addGestureRecognizer(tap)
        
        // Set subView
        infoView.snp.makeConstraints({
            make in
            make.center.equalTo(self.view.center)
            make.width.equalTo(300)
            make.height.equalTo(600)
        })
        // Set avatar
        infoView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints({
            make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(100)
            make.width.equalTo(100)
        })
        avatarImageView.image = UIImage(named: "avatar")?.toCircle()
        // Set textFields
        infoView.addSubview(userNameTextField)
        userNameTextField.snp.makeConstraints({
            make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(150)
            make.height.equalTo(60)
            make.width.equalTo(300)
        })
        userNameTextField.clearButtonMode = .always
        
        infoView.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints({
            make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(220)
            make.height.equalTo(60)
            make.width.equalTo(300)
        })
        passwordTextField.isSecureTextEntry = true
        passwordTextField.clearButtonMode = .always
        // Set Button
        let signInButton = RaisedButton(title: "Sign in",titleColor: .white)
        signInButton.titleLabel?.font = UIUtils.commonFont(size: 24)
        signInButton.pulseColor = .white
        signInButton.backgroundColor = Color.blue.accent1
        infoView.addSubview(signInButton)
        signInButton.snp.makeConstraints({
            make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(320)
            make.height.equalTo(40)
            make.width.equalTo(300)
        })
        signInButton.addTarget(self, action: #selector(self.touchSignIn), for: .touchUpInside)
        
        let signUpButton = FlatButton(title: "Sign up",titleColor: Color.blue.accent1)
        signUpButton.titleLabel?.font = UIUtils.commonFont(size: 14)
        infoView.addSubview(signUpButton)
        signUpButton.snp.makeConstraints({
            make in
            make.left.equalTo(signInButton.snp.centerX)
            make.top.equalToSuperview().offset(400)
            make.height.equalTo(40)
            make.width.equalTo(150)
        })
        
        let forgetPasswordButton = FlatButton(title: "Forget password?",titleColor: Color.blue.accent1)
        forgetPasswordButton.titleLabel?.font = UIUtils.commonFont(size: 14)
        infoView.addSubview(forgetPasswordButton)
        forgetPasswordButton.snp.makeConstraints({
            make in
            make.right.equalTo(signInButton.snp.centerX)
            make.top.equalToSuperview().offset(400)
            make.height.equalTo(40)
            make.width.equalTo(150)
        })
        
        // observe phone number and change the avatar
        changePhoneNumber = userNameTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: {
                self.changeAvatar(phoneNumber:$0)
            })
    }
    func changeAvatar(phoneNumber:String){
        
        NetworkUtils.getRequest(method: "/account/getAvatar/" + phoneNumber, parameters: nil, header: nil).responseJSON(completionHandler: {
            response in
            if response.result.isSuccess{
                if let value = response.result.value {
                    let json = JSON(value)
                    if json["code"].int == 200 {
                        let url = URL(string: json["data"]["avatar"].string!)
                        do{
                            let data = try Data(contentsOf: url!)
                            self.avatarImageView.image = UIImage(data: data)?.toCircle()
                        }catch let error as NSError{
                            print(error)
                        }
                    }else{
                        self.avatarImageView.image = UIImage(named: "avatar")?.toCircle()
                    }
                }
            }
        })
    }
    @objc func dismisskeyboard(){
        self.view.endEditing(true)
    }
    @objc func touchSignIn(){
        let parameters:Parameters = ["password": passwordTextField.text!,"phone":userNameTextField.text!]
        NetworkUtils.postRequest(method: "/account/common/login", parameters: parameters, header: nil).responseJSON(completionHandler: {
            response in
            if response.result.isSuccess{
                if let value = response.result.value {
                    let json = JSON(value)
                    if json["code"].int == 200 {
                        Defaults[.username] = json["data"]["userInfo"]["username"].string
                        Defaults[.password] = self.passwordTextField.text!
                        Defaults[.avatar] = json["data"]["userInfo"]["avatar"].string
                        Defaults[.phoneNumber] = json["data"]["userInfo"]["phoneNumber"].string
                        Defaults[.token] = json["data"]["token"].string
                        let alert = SCLAlertView(appearance: UIUtils.appearance)
                        alert.addButton("OK", action: {
                            self.changePhoneNumber.dispose()
                        })
                        alert.showSuccess("Welcome", subTitle: "Sign in Success")
                    }else{
                        let alert = SCLAlertView(appearance: UIUtils.appearance)
                        alert.addButton("OK", action: {
                            self.passwordTextField.text = ""
                        })
                        alert.showError("Sign in Fail", subTitle: "Please check your Phone Number or Password")
                    }
                }
            }else{
                let alert = SCLAlertView(appearance: UIUtils.appearance)
                alert.addButton("OK", action: {
                    self.passwordTextField.text = ""
                })
                alert.showError("Network Fail", subTitle: "Please check your network")
            }
        })
    }
}

