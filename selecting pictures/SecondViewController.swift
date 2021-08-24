//
//  ViewController.swift
//  selecting pictures
//
//  Created by 細渕雅貴 on 2021/07/12.
//

import UIKit
import AVFoundation

extension SecondViewController: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput,
                    didFinishProcessingPhoto photo: AVCapturePhoto,
                    error: Error?){
        if let imageData = photo.fileDataRepresentation() {
            let uiImage = UIImage(data: imageData)
            UIImageWriteToSavedPhotosAlbum(uiImage!, nil, nil, nil)
        }
    }
}

class SecondViewController: UIViewController {
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        captureSession.startRunning()
        styleCaptureButton()
    }
    //シャッターボタン
    @IBOutlet weak var cameraButton: UIButton!
    
    //シャッターボタンを押す
    
    @IBAction func cameraButton_Touched(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        //フラッシュ
        settings.flashMode = .auto
        
        self.photoOutPut?.capturePhoto(with: settings, delegate: self as AVCapturePhotoCaptureDelegate)
    }
    //デバイスの入出力を管理するオブジェクト
    var captureSession = AVCaptureSession()
    
    //カメラの画質設定
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    var mainCamera: AVCaptureDevice?
    
    var innerCamera: AVCaptureDevice?
    
    var currentDevice: AVCaptureDevice?
    
    func setupDevice() {
        //カメラデバイスのプロパティ設定
        let deviceDiscoverySession =
            AVCaptureDevice.DiscoverySession(
                deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
                mediaType: AVMediaType.video,
                position:AVCaptureDevice.Position.unspecified
        )
        let devices = deviceDiscoverySession.devices
        
        for device in devices{
            if device.position == AVCaptureDevice.Position.back{
                mainCamera = device
            }else if device.position == AVCaptureDevice.Position.front{
                innerCamera = device
            }
            
        }
        currentDevice = mainCamera
    }
    //出力を行うオブジェクト
    var photoOutPut: AVCapturePhotoOutput?
    
    func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
            captureSession.addInput(captureDeviceInput)
            photoOutPut = AVCapturePhotoOutput()
            photoOutPut!.setPreparedPhotoSettingsArray(
                                [AVCapturePhotoSettings(
                                    format: [AVVideoCodecKey : AVVideoCodecType.jpeg])],
                                    completionHandler: nil)
            captureSession.addOutput(photoOutPut!)
        }catch{
            print("error")
        }
    }
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    func setupPreviewLayer() {
        
        //初期化（イニシャライズ）
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //プレビューレイヤーの縦横比を定める
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        //プレビューレイヤーの表示の向き
        
            self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
           
        self.cameraPreviewLayer?.frame = view.frame
        
        self.view.layer.insertSublayer(self.cameraPreviewLayer!, at: 0)
       
        
    }
    
    //ボタンのデザイン
    func styleCaptureButton() {
        cameraButton.layer.cornerRadius = 38.0
        cameraButton.backgroundColor = UIColor.red
        cameraButton.layer.borderColor = UIColor.white.cgColor
        cameraButton.layer.borderWidth = 6.0
    }
    
}
