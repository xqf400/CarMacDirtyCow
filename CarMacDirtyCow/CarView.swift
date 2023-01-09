//
//  ViewController.swift
//  CarMacDirtyCow
//
//  Created by Fabian Kuschke on 09.01.23.
//

import UIKit

class CarView: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var stackViewReplace: UIStackView!
    @IBOutlet weak var consoleTextView: UITextView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    @IBOutlet weak var darkImageView: UIImageView!
    @IBOutlet weak var lightImageView: UIImageView!
    @IBOutlet weak var selectedImage: UIImageView!
    
    @IBOutlet weak var selecetImageButtonOutlet: UIButton!
    
    @IBOutlet weak var replaceDarkButtonOutlet: UIButton!
    @IBOutlet weak var replaceLightButtonOutlet: UIButton!
    var pickedImage:UIImage?
    
    private let lightPath = "/System/Library/PrivateFrameworks/CarPlayUIServices.framework/WallpaperBlack-Light.heic"
    
    private let darkPath = "/System/Library/PrivateFrameworks/CarPlayUIServices.framework/WallpaperBlack-Dark.heic"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        NotificationCenter.default.addObserver(self, selector: #selector(writeToConsole), name: Notification.Name("writeToConsole"), object: nil)

    }
    
    @objc
    func writeToConsole(notification:Notification){
        let userInfo = notification.userInfo
        let message = userInfo!["message"] as! String
        consoleTextView.text = consoleTextView.text + "\n" + message
        let location = consoleTextView.text.count - 1
        let bottom = NSMakeRange(location, 1)
        consoleTextView.scrollRangeToVisible(bottom)
    }
    
    func setUI(){
        activityLoader.isHidden = true
        stackViewReplace.isHidden = true
        selecetImageButtonOutlet.layer.cornerRadius = 8
        selecetImageButtonOutlet.layer.borderWidth = 2
        selecetImageButtonOutlet.layer.borderColor = UIColor.gray.cgColor
        replaceDarkButtonOutlet.layer.cornerRadius = 8
        replaceDarkButtonOutlet.layer.borderWidth = 2
        replaceDarkButtonOutlet.layer.borderColor = UIColor.gray.cgColor
        replaceLightButtonOutlet.layer.cornerRadius = 8
        replaceLightButtonOutlet.layer.borderWidth = 2
        replaceLightButtonOutlet.layer.borderColor = UIColor.gray.cgColor
        
        
        let systemVersion = UIDevice.current.systemVersion
        let infoStr = "Model: \(modelIdentifier()), iOS Version: \(systemVersion)"
        infoLabel.text = infoStr
        
        getSystemImage()
    }
    @IBAction func infoButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Info", message: "Dev and Credits", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Developer", style: .default, handler: { action in
            if let url = URL(string: "https://twitter.com/xqf400") {
                UIApplication.shared.open(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "MacDirtyCow exploit", style: .default, handler: { action in
            if let url = URL(string: "https://github.com/zhuowei") {
                UIApplication.shared.open(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "Trolllock-Reborn", style: .default, handler: { action in
            if let url = URL(string: "https://github.com/haxi0/TrollLock-Reborn") {
                UIApplication.shared.open(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func replaceDarkButtonAction(_ sender: Any) {
        if pickedImage != nil {
            overWriteImage(path: darkPath, image: pickedImage!, name: "WallpaperBlack-Dark.heic")
            // getSystemImage()
        }
    }
    @IBAction func replaceLightButtonAction(_ sender: Any) {
        if pickedImage != nil {
            overWriteImage(path: lightPath, image: pickedImage!, name: "WallpaperBlack-Light.heic")
            // getSystemImage()
        }
    }

    
    @IBAction func chooseImageButtonAction(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = false
        self.present(picker, animated: true)
    }
    
    func getSystemImage(){
        let data1 = try! Data(contentsOf: URL(fileURLWithPath: lightPath))
        let image1 = UIImage(data: data1)
        lightImageView.image =  image1
        
        let data2 = try! Data(contentsOf: URL(fileURLWithPath: darkPath))
        let image2 = UIImage(data: data2)
        darkImageView.image =  image2
    }
    
    func overWriteImage(path: String, image:UIImage, name: String){
        activityLoader.isHidden = false
        activityLoader.startAnimating()

        let imageData = pickedImage!.jpegData(compressionQuality: 0.1)
        overwrite(imageData, path, name)
    }
    
    
    func modelIdentifier() -> String {
        var sysinfo = utsname()
        uname(&sysinfo)
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    

}

extension CarView:UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        pickedImage = info[.originalImage] as? UIImage
        selectedImage.image = pickedImage
        stackViewReplace.isHidden = false
        self.dismiss(animated: true)
    }
}

