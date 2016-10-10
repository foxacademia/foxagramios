//
//  CameraViewController.swift
//  Foxagram
//
//  Created by Jose Eduardo Quintero Gutiérrez on 26/09/16.
//
//

import UIKit
import AVFoundation
import Alamofire

class CameraViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet var camera_view: UIView!
    @IBOutlet var take_photo_btn: UIButton!
    @IBOutlet var image_preview: UIImageView!
    @IBOutlet var cancel_button: UIButton!
    @IBOutlet var photo_title: UITextField!
    @IBOutlet var crop_preview: UIView!
    @IBOutlet var upload_button: UIButton!
    @IBOutlet var edit_title_button: UIButton!
    
    var session = AVCaptureSession()
    var captureDevice : AVCaptureDevice?
    var stillImageOutput: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
    var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    var photo_taken: Bool?
    
    override func viewDidAppear(_ animated: Bool) {
        videoPreviewLayer.frame = camera_view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPreset1920x1080
        
        let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        let input: AVCaptureDeviceInput = try! AVCaptureDeviceInput(device: backCamera)
        
        if session.canAddInput(input) {
            session.addInput(input)
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            
            if session.canAddOutput(stillImageOutput){
                session.addOutput(stillImageOutput)
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
                videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                videoPreviewLayer.connection.videoOrientation = .portrait
                camera_view.layer.addSublayer(videoPreviewLayer)
                session.startRunning()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isPhotoTaken(taken: false)
        initTakePhotoButton()
        
        cancel_button.addTarget(self, action: #selector(CameraViewController.cancelPhoto(_:)), for: .touchDown)
    }
    
    func initTakePhotoButton(){
        take_photo_btn.layer.cornerRadius = 35.0
        take_photo_btn.layer.borderWidth = 5.0
        take_photo_btn.layer.borderColor = UIColor.white.cgColor
    }
    
    func isPhotoTaken(taken: Bool){
        if taken == true {
            self.image_preview.isHidden = false
            self.upload_button.isHidden = false
            self.photo_title.isHidden = false
            self.camera_view.isHidden = true
            self.take_photo_btn.isHidden = true
            self.edit_title_button.isHidden = false
        }else{
            self.image_preview.isHidden = true
            self.upload_button.isHidden = true
            self.photo_title.isHidden = true
            self.camera_view.isHidden = false
            self.take_photo_btn.isHidden = false
            self.edit_title_button.isHidden = true
        }
    }
    
    
    func cancelPhoto(_ sender: UIButton){
        if photo_taken == true {
            self.isPhotoTaken(taken: false)
            self.photo_taken = false
            self.rotateButton(arrow_button: self.cancel_button, toValue: 0)

        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func takePhoto(_ sender: AnyObject) {

        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo){
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (sampleBuffer, error) in
                
                if sampleBuffer != nil {
                    let image_data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    
                    let data_provider = CGDataProvider(data: image_data as! CFData)
                    let cgImageRef = CGImage(jpegDataProviderSource: data_provider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
                    
                    var image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                    
                    let screenSize: CGRect = UIScreen.main.bounds

                    
                    image = self.cropToBounds(image: image, width: Double(screenSize.width), height: Double(screenSize.width))
                    
                    self.rotateButton(arrow_button: self.cancel_button, toValue: M_PI_2)
                    self.photo_taken = true
                    self.isPhotoTaken(taken: true)
                    self.image_preview.image = image
                    
                }
                
            })
        }
    }


    @IBAction func uploadPhoto(_ sender: AnyObject) {
        let image_to_send = UIImageJPEGRepresentation(self.image_preview.image!, 0.2)
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(image_to_send!, withName: "photo", fileName: "sd.jepg"
                    , mimeType: "image/jpeg")
                multipartFormData.append("title".data(using: String.Encoding.utf8)!, withName: "title")
            },
            to: "\(Utilities.url)photo/upload",
            headers: Me.TOKEN,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                    
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        print(response)
                        let json:JSON = JSON(response)
                        print(json)
                        self.image_preview.isHidden = true
                    }
                    
                case .failure(let encodingError):
                    print("ERROR RESPONSE: \(encodingError)")
                }
            }
        )
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    func rotateButton(arrow_button: UIButton,  toValue: Any) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        //rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = toValue
        rotationAnimation.duration = 0.3
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)

        //Keep final frame of animations
        rotationAnimation.fillMode = kCAFillModeForwards;
        rotationAnimation.isRemovedOnCompletion = false;
        
        arrow_button.layer.add(rotationAnimation, forKey: nil)
    }
    @IBAction func editTitle(_ sender: AnyObject) {
        photo_title.becomeFirstResponder()
    }
    
    
    
    /*func openCamera(){
     if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
     let imagePicker = UIImagePickerController()
     imagePicker.delegate = self
     imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
     imagePicker.allowsEditing = false
     self.present(imagePicker, animated: true, completion: nil)
     }
     }
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
     
     self.dismiss(animated: true, completion: nil);
     
     let photo = info[UIImagePickerControllerOriginalImage] as? UIImage
     let imageData = UIImageJPEGRepresentation(photo!, 0.2)
     
     Alamofire.upload(
     multipartFormData: { multipartFormData in
     multipartFormData.append(imageData!, withName: "photo", fileName: "sd.jepg"
     , mimeType: "image/jpeg")
     multipartFormData.append("title".data(using: String.Encoding.utf8)!, withName: "title")
     },
     to: "\(Utilities.url)photo/upload",
     headers: Me.TOKEN,
     encodingCompletion: { encodingResult in
     
     switch encodingResult {
     
     case .success(let upload, _, _):
     upload.responseJSON { response in
     print(response)
     let json:JSON = JSON(response)
     print(json)
     }
     case .failure(let encodingError):
     print("ERROR RESPONSE: \(encodingError)")
     }
     }
     )
     }*/
}
