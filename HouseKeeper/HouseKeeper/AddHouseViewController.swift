//
//  AddHouseViewController.swift
//  Open House
//
//  Created by Arjun Chib on 11/9/16.
//  Copyright © 2016 Profectus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


// This class contains the UI elements and the underlying functionality for adding a house
class AddHouseViewController: PopUpViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    let address = TextField()
    let photoView = UIImageView()
    let imagePicker = UIImagePickerController()

    // complete viewDidLoad() responsory function
    override func viewDidLoad() {
        super.viewDidLoad()

        // title
        titleLabel.text = "Add House"

        // address
        address.placeholder = "Address"
        address.layer.borderColor = Style.redColor.cgColor
        address.delegate = self
        
        // photo view
        photoView.layer.borderColor = Style.redColor.cgColor
        photoView.layer.borderWidth = 2.0
        photoView.layer.cornerRadius = 20.0
        photoView.layer.masksToBounds = true
        photoView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddHouseViewController.handleAddImage))
        photoView.addGestureRecognizer(tap)
        
        // image picker
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!

        // submit
        submit.addTarget(self, action: #selector(AddHouseViewController.handleAddHouse), for: .touchUpInside)

        // add subviews
        view.addSubview(address)
        view.addSubview(photoView)

        // make constraints
        address.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(40)
        }
        
        photoView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(address.snp.bottom).offset(10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(200)
        }
    }
    
    override func layoutFrameWithKeyboard(textField: UITextField) {
        let width = Style.screenWidth - 40.0
        let height = CGFloat(400.0)
        let x = CGFloat(20.0)
        let y = Style.screenHeight - keyboardHeight - height - 20.0
        let frame  = CGRect(x: x, y: y, width: width, height: height)
        
        self.view.frame = frame
    }
    
    override func layoutFrameWithoutKeyboard() {
        let width = Style.screenWidth - 40.0
        let height = CGFloat(400.0)
        let x = CGFloat(20.0)
        let y = Style.screenHeight / 2.0 - height / 2.0
        let frame  = CGRect(x: x, y: y, width: width, height: height)
        
        self.view.frame = frame
    }

    func handleAddHouse() {
        let newHouse = House(hid: 0, address: address.text!)
        if photoView.image != nil {
            newHouse.image = photoView.image!
        }
        MyHouses.shared.addHouse(house: newHouse)
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "reloadHouses")))
        self.handleDismiss()
    }
    
    func handleAddImage() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        photoView.contentMode = .scaleAspectFill
        photoView.image = chosenImage
        layedout = false
        dismiss(animated:true, completion: {
            self.layedout = false
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        layedout = false
        dismiss(animated: true, completion: {
            self.layedout = false
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
