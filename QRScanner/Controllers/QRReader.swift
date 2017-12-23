
import UIKit

final class QRReader: UIViewController
{
    // MARK:- Constants
    
    
    // MARK:- Variables
    
    
    // MARK:- Outlets
    
    @IBOutlet private weak var headerPanel: UIView! { didSet {
        headerPanel.setShadow()
        }}
    @IBOutlet private weak var btnScan: UIButton! { didSet {
        btnScan.setShadow(with: #colorLiteral(red: 0.2333111465, green: 0.5155668259, blue: 0.9542741179, alpha: 1))
        btnScan.setCornerRadius()
        } }
    @IBOutlet private weak var resultsPanel: UIView! { didSet {
        resultsPanel.setShadow()
        }}
    @IBOutlet private weak var resultsHeaderPanel: UIView! { didSet {
        resultsHeaderPanel.setShadow()
        }}
    @IBOutlet fileprivate weak var lblResults: UILabel!
    
    
    
    // MARK:- Overridden functions
    
    
    
    // MARK:- Actions
    
    @IBAction private func scanCodeOnClick(_ sender: UIButton) {
        guard let capturePage = storyboard?.instantiateViewController(withIdentifier: Constants.CaptureView) as? Capture else { return }
        capturePage.readerDelegate = self
        present(capturePage, animated: true)
    }

}

// MARK:- Code delegate function
extension QRReader: CodeDelegate
{
    internal func decodedCode(text: String) {
        lblResults.text = text
    }
}


// MARK:-  Helper Extenstions

extension UIView
{
    
    fileprivate func setShadow(with color: UIColor = UIColor.black)-> Void {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 1.5
        layer.shadowOpacity = 0.4
    }
    
    fileprivate func setCornerRadius(with value: CGFloat = 2.0)-> Void {
        layer.cornerRadius = value
    }
    
}






















