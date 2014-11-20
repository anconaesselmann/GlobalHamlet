import AVFoundation
import UIKit

class QrReader: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession:AVCaptureSession!
    var videoPreviewLayer:AVCaptureVideoPreviewLayer!
    var viewPreview:UIView!
    var isReading:Bool = false
    var callBack: (String) -> Void!
    
    init(displayView: UIView, callBack:(String)->Void) {
        self.viewPreview = displayView
        self.callBack = callBack
    }
    
    func startReading() -> Bool {
        var error:NSError?
        
        let captureDevice:AVCaptureDevice! = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        if captureDevice == nil {
            NSLog("Could not initiate camera.")
            return false;
        }
        
        var input:AVCaptureDeviceInput! = AVCaptureDeviceInput.deviceInputWithDevice(captureDevice, error: &error) as AVCaptureDeviceInput
        
        if (input == nil) {
            NSLog(error!.localizedDescription)
            return false;
        }
        
        captureSession = AVCaptureSession()
        captureSession.addInput(input)
        
        var captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        
        var dispatchQueue = dispatch_queue_create("com.anconaesselmann.QrReader", DISPATCH_QUEUE_CONCURRENT);
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatchQueue)
        captureMetadataOutput.metadataObjectTypes.append(AVMetadataObjectTypeQRCode)
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer.frame = viewPreview.layer.bounds
        viewPreview.layer.addSublayer(videoPreviewLayer)
        
        captureSession.startRunning()
        isReading = true
        return true
    }
    
    func stopReading() {
        if isReading {
            captureSession.stopRunning()
            captureSession = nil;
            
            videoPreviewLayer.removeFromSuperlayer()
            isReading = false
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if (metadataObjects != nil && metadataObjects.count > 0) {
            var metadataObj:AVMetadataMachineReadableCodeObject! = metadataObjects[0] as AVMetadataMachineReadableCodeObject
            
            if metadataObj != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.callBack(metadataObj.stringValue)
                    self.stopReading()
                })
            }
        }
    }
}