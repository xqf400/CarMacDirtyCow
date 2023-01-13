//
//  ViewController.swift
//  CarMacDirtyCow
//
//  Created by XQF on 09.01.23.
//

import UIKit

class CarView: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var consoleTextView: UITextView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    
    @IBOutlet weak var darkImageView: UIImageView!
    @IBOutlet weak var lightImageView: UIImageView!
    
    @IBOutlet weak var replaceDarkButtonOutlet: UIButton!
    @IBOutlet weak var replaceLightButtonOutlet: UIButton!
    
    @IBOutlet weak var selectedLightButtonOutlet: UIButton!
    @IBOutlet weak var selectedDarkButtonOutlet: UIButton!
    
    @IBOutlet weak var savedLightUiimageView: UIImageView!
    @IBOutlet weak var savedDarkUiimageView: UIImageView!
    
    var isDarkWallpaper = false
    
    private let lightPath = "/System/Library/PrivateFrameworks/CarPlayUIServices.framework/WallpaperBlack-Light.heic"
    
    private let darkPath = "/System/Library/PrivateFrameworks/CarPlayUIServices.framework/WallpaperBlack-Dark.heic"

    private let darkImageName = "WallpaperBlack-Dark.heic"
    private let lightImageName = "WallpaperBlack-Light.heic"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.observerFromKern(notification:)), name: Notification.Name("kernSuccess"), object: nil)
        setUI()
    }
    
    private func setUI(){
        activityLoader.isHidden = true
        activityLoader.transform = CGAffineTransform(scaleX: 4.0, y: 4.0)

        selectedLightButtonOutlet.layer.cornerRadius = 8
        selectedLightButtonOutlet.layer.borderWidth = 2
        selectedLightButtonOutlet.layer.borderColor = UIColor.gray.cgColor
        selectedDarkButtonOutlet.layer.cornerRadius = 8
        selectedDarkButtonOutlet.layer.borderWidth = 2
        selectedDarkButtonOutlet.layer.borderColor = UIColor.gray.cgColor
        replaceDarkButtonOutlet.layer.cornerRadius = 8
        replaceDarkButtonOutlet.layer.borderWidth = 2
        replaceDarkButtonOutlet.layer.borderColor = UIColor.gray.cgColor
        replaceLightButtonOutlet.layer.cornerRadius = 8
        replaceLightButtonOutlet.layer.borderWidth = 2
        replaceLightButtonOutlet.layer.borderColor = UIColor.gray.cgColor
        
        
        let systemVersion = UIDevice.current.systemVersion
        let infoStr = "Model: \(modelIdentifier()), iOS Version: \(systemVersion)"
        infoLabel.text = infoStr
        
        getLocalImages()
        getSystemImages()
    }
    
    @objc func observerFromKern(notification: Notification) {
        getSystemImages()
        activityLoader.stopAnimating()
        activityLoader.isHidden = true
        replaceDarkButtonOutlet.isHidden = false
        replaceLightButtonOutlet.isHidden = false
        selectedLightButtonOutlet.isHidden = false
        selectedDarkButtonOutlet.isHidden = false
        
        let userInfo = notification.userInfo
        addMessageToConsole(message: userInfo!["KERN"] as! String)
        addMessageToConsole(message: userInfo!["PASS"] as! String)

    }

    
    
    @IBAction func infoButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "🐮Info🐮", message: "Dev and Credits", preferredStyle: .alert)
        
        
        
        alert.addAction(UIAlertAction(title: "🐥Follow me on Twitter🐤", style: .default, handler: { action in
            if let url = URL(string: "https://twitter.com/xqf400") {
                UIApplication.shared.open(url)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "🎇Example Images🌄", style: .default, handler: { action in
            if let url = URL(string: "https://github.com/xqf400/CarMacDirtyCow/tree/main/Images/TestImages") {
                UIApplication.shared.open(url)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "🙏 @Ian Beer", style: .default, handler: { action in
            if let url = URL(string: "https://twitter.com/i41nbeer") {
                UIApplication.shared.open(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "🙏 @zhuowei Demo", style: .default, handler: { action in
            if let url = URL(string: "https://github.com/zhuowei") {
                UIApplication.shared.open(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "🙏@Trolllock-Reborn", style: .default, handler: { action in
            if let url = URL(string: "https://github.com/haxi0/TrollLock-Reborn") {
                UIApplication.shared.open(url)
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func selectLightButtonAction(_ sender: Any) {
        isDarkWallpaper = false
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = false
        self.present(picker, animated: true)
    }
    
    @IBAction func selectDarkButtonAction(_ sender: Any) {
        isDarkWallpaper = true
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = false
        self.present(picker, animated: true)
    }
    
    @IBAction func replaceDarkButtonAction(_ sender: Any) {
        if savedDarkUiimageView.image != nil {
            overWriteImage(path: darkPath, image: savedDarkUiimageView.image!, name: darkImageName)
        }
    }
    @IBAction func replaceLightButtonAction(_ sender: Any) {
        if savedLightUiimageView.image != nil {
            overWriteImage(path: lightPath, image: savedLightUiimageView.image!, name: lightImageName)
        }
    }

    
    private func getLocalImages(){
        do{
            let lightUrl = try FileManager.default.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(lightImageName)
            let dataLight = try Data(contentsOf: lightUrl)
            savedLightUiimageView.image = UIImage(data: dataLight)
        }catch{
            print("no light image in local: \(error)")
            savedLightUiimageView.image = UIImage(named:"alpes")
        }
        do{
            let darkUrl = try FileManager.default.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(darkImageName)
            let dataLight = try Data(contentsOf: darkUrl)
            savedDarkUiimageView.image = UIImage(data: dataLight)
        }catch{
            print("no dark timage in local: \(error)")
            savedDarkUiimageView.image = UIImage(named:"AiCow1")

        }
    }
    

    
    
    private func getSystemImages(){
        let data1 = try! Data(contentsOf: URL(fileURLWithPath: lightPath))
        let image1 = UIImage(data: data1)
        lightImageView.image =  image1
        
        let data2 = try! Data(contentsOf: URL(fileURLWithPath: darkPath))
        let image2 = UIImage(data: data2)
        darkImageView.image =  image2
    }
    
    private func overWriteImage(path: String, image:UIImage, name: String){
        activityLoader.isHidden = false
        activityLoader.startAnimating()
        replaceDarkButtonOutlet.isHidden = true
        replaceLightButtonOutlet.isHidden = true
        selectedLightButtonOutlet.isHidden = true
        selectedDarkButtonOutlet.isHidden = true

        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            return
        }
        overwrite(imageData, path, name)
    }
    
    func addMessageToConsole(message:String){
        consoleTextView.text = consoleTextView.text + "\n" + message
        let location = consoleTextView.text.count - 1
        let bottom = NSMakeRange(location, 1)
        consoleTextView.scrollRangeToVisible(bottom)
    }
    
    private func modelIdentifier() -> String {
        var sysinfo = utsname()
        uname(&sysinfo)
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    
    //    func respring() {
    //        guard let window = UIApplication.shared.windows.first else { return }
    //        while true {
    //            window.snapshotView(afterScreenUpdates: false)
    //        }
    //    }

}

extension CarView:UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if isDarkWallpaper {
            savedDarkUiimageView.image = info[.originalImage] as? UIImage
            saveImage(savedDarkUiimageView.image!.jpegData(compressionQuality: 0.1), darkImageName)
        }else{
            savedLightUiimageView.image = info[.originalImage] as? UIImage
            saveImage(savedLightUiimageView.image!.jpegData(compressionQuality: 0.1), lightImageName)
        }
        self.dismiss(animated: true)
    }
}

