
import UIKit
import AVFoundation

final class Capture: UIViewController
{
    
    // MARK:- Constants
    
    
    // MARK:- Variables
    
    fileprivate var captureSesstion: AVCaptureSession!, previewLayer: AVCaptureVideoPreviewLayer!
    internal weak var readerDelegate: CodeDelegate?
    
    
    // MARK:- Outlets
    
    
    // MARK:- Overridden functions
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        prepareCaptureLayer()
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (!captureSesstion.isRunning) {
            captureSesstion.startRunning()
        }
    }
    
    internal override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (captureSesstion.isRunning) {
            captureSesstion.stopRunning()
        }
    }
    
    
    // MARK:- Actions
    
}

// MARK:-  Helper functions

extension Capture
{
    
    fileprivate func prepareCaptureLayer()-> Void {
        captureSesstion = AVCaptureSession()
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if (captureSesstion.canAddInput(videoInput)) {
                captureSesstion.addInput(videoInput)
            } else {
                dailog(with: "can't scanning")
                return
            }
        } catch {
            print("error is: \(error)")
            return
        }
        let output = AVCaptureMetadataOutput()
        if (captureSesstion.canAddOutput(output)) {
            captureSesstion.addOutput(output)
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypePDF417Code]
        } else {
            dailog(with: "can't scanning")
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSesstion)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        view.layer.addSublayer(previewLayer)
        captureSesstion.startRunning()

    }
    
    fileprivate func dailog(with message: String)-> Void {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.view.tintColor = #colorLiteral(red: 0.2333111465, green: 0.5155668259, blue: 0.9542741179, alpha: 1)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
    
}

// MARK:- AV Capture delegate functions

extension Capture: AVCaptureMetadataOutputObjectsDelegate
{
    internal func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        captureSesstion.stopRunning()
        if let metadata = metadataObjects.first, let readableMetadata = metadata as? AVMetadataMachineReadableCodeObject {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            print("value is: \(readableMetadata.stringValue)")
            readerDelegate?.decodedCode(text: readableMetadata.stringValue)
        }
        dismiss(animated: true)
    }
    
}


// MARK:- Custom QRCodeDelegate
protocol CodeDelegate: class {
    func decodedCode(text: String) -> Void
}






















