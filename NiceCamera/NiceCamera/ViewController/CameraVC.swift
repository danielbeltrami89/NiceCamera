//
//  CameraVC.swift
//  NiceCamera
//
//  Created by Informatica Labo Mac on 12/11/19.
//  Copyright © 2019 Dan Beltrami. All rights reserved.
//

import UIKit
import AVFoundation

public class CameraVC: UIViewController, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
     @IBOutlet var previewView: UIView!
        @IBOutlet var captureImageView: UIImageView!
        @IBOutlet var oldImageView: UIImageView!
        @IBOutlet var btnVerImagens: UIButton!
        @IBOutlet var retanguloView: UIView!
        
        let imagePick = UIImagePickerController()
        
        var captureSession: AVCaptureSession!
        var stillImageOutput: AVCapturePhotoOutput!
        var videoPreviewLayer: AVCaptureVideoPreviewLayer!
        
        var imagens = [UIImage]()

        @IBAction func didTakePhoto(_ sender: Any) {
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            stillImageOutput.capturePhoto(with: settings, delegate: self)
        }
        
        @IBAction func didPressGallery(_ sender: Any) {
            imagePick.allowsEditing = false
            imagePick.sourceType = .photoLibrary
                   
            present(imagePick, animated: true, completion: nil)
        }
        
        @IBAction func didPressVer(_ sender: Any) {
            mostraPreview()
        }
        
        @IBAction func didPressFechar(_ sender: Any) {
        }
        
    override public func viewDidLoad() {
            super.viewDidLoad()
            
            imagePick.delegate = self
        }
        
    override public func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
                  
            captureSession = AVCaptureSession()
            captureSession.sessionPreset = .hd1920x1080
            
            guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
                else {
                    print("Unable to access back camera!")
                    return
            }
            
            do {
                let input = try AVCaptureDeviceInput(device: backCamera)
                
                stillImageOutput = AVCapturePhotoOutput()

                if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                    captureSession.addInput(input)
                    captureSession.addOutput(stillImageOutput)
                    setupLivePreview()
                }
            }
            catch let error  {
                print("Error Unable to initialize back camera:  \(error.localizedDescription)")
            }
        }
        
    override public func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            self.captureSession.stopRunning()
        }
        
        //override var prefersStatusBarHidden: Bool { return true }
        
        func setupLivePreview() {
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer.videoGravity = .resizeAspectFill
            videoPreviewLayer.connection?.videoOrientation = .portrait
            previewView.layer.addSublayer(videoPreviewLayer)
           
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
                DispatchQueue.main.async {
                    self.videoPreviewLayer.frame = self.previewView.bounds
                }
            }
        }
        
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            
            guard let imageData = photo.fileDataRepresentation()
                else { return }
            
            let image = UIImage(data: imageData)
            
            let imgEdit = image?.croppedImagem(inRect: CGRect(
                x: retanguloView.frame.origin.x,
                y: retanguloView.frame.origin.y,
                    width: 1080,
                    height: 1560))
            
            exibe(imagem: imgEdit!)
            
        }
        
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                exibe(imagem: pickedImage)
            }
            dismiss(animated: true, completion: nil)
        }
        
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
        
        func exibe(imagem: UIImage) {
            btnVerImagens.isEnabled = true
            captureImageView.isHidden = false
            captureImageView.image = imagem
            imagens.append(imagem)
            
            if imagens.count > 1 {
                oldImageView.image = imagens[imagens.count - 2]
                oldImageView.isHidden = false
            }
        }
        
        func mostraPreview() {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PreviewVC") as! PreviewVC
            vc.imagens = self.imagens
            self.present(vc, animated: true, completion: {
                self.imagens = []
                self.btnVerImagens.isEnabled = false
                self.captureImageView.isHidden = true
                self.oldImageView.isHidden = true
            })
        }
    }

    public extension UIImage {
       
        func croppedImagem(inRect rect: CGRect) -> UIImage {
            let rad: (Double) -> CGFloat = { deg in
                return CGFloat(deg / 180.0 * .pi)
            }
            
            let rotation = CGAffineTransform(rotationAngle: rad(-90))
            var rectTransform = rotation.translatedBy(x: -size.width, y: 0)
            rectTransform = rectTransform.scaledBy(x: scale, y: scale)
            
            let transformedRect = rect.applying(rectTransform)
            let imageRef = cgImage!.cropping(to: transformedRect)!
            let result = UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
            
            return result
        }
}
