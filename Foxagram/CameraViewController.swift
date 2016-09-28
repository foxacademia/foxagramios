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

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var camera_view: UIView!
    @IBOutlet var take_photo_btn: UIButton!
    
    var session = AVCaptureSession()
    var captureDevice : AVCaptureDevice?
    var stillImageOutput: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
    var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    override func viewDidAppear(_ animated: Bool) {
        
        videoPreviewLayer.frame = camera_view.bounds
    
    }
    override func viewWillAppear(_ animated: Bool) {
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetPhoto
        
        let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        let input: AVCaptureDeviceInput = try! AVCaptureDeviceInput(device: backCamera)
        
        if session.canAddInput(input){
            session.addInput(input)
        }
        
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        if session.canAddOutput(stillImageOutput){
            session.canAddOutput(stillImageOutput)
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
            videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientation.portrait
            camera_view.layer.addSublayer(videoPreviewLayer)
            //self.view.layer.addSublayer(videoPreviewLayer)
            session.startRunning()

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        take_photo_btn.layer.cornerRadius = 30.0
        
    }

    func openCamera(){
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
            headers: Me.headers,
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
     

    }
    
    
    func beginSession() {
       /* var err : NSError? = nil
   
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        
        if err != nil {
            println("error: \(err?.localizedDescription)")
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.camera_view.layer.addSublayer(previewLayer)
        previewLayer?.frame = self.view.layer.frame
        captureSession.startRunning()*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func takePhoto(_ sender: AnyObject) {
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo){
            
        }
    }

}
