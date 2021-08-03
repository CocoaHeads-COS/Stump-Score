//
//  KeypadViewController.swift
//  KeypadViewController
//
//  Created by Tom Harrington on 8/2/21.
//

import UIKit

class KeypadViewController: UIViewController {
    @IBOutlet var keypadButtons: [UIButton]! {
        didSet {
            keypadButtons.forEach {
                $0.backgroundColor = .black
                $0.setTitleColor(.systemGreen, for: .normal)
                // Using .filled() (or any configuration?) overrides font size, and setting it back on titleLabel doesn't have any effect
//                $0.configuration = .filled()
            }
        }
    }
    @IBOutlet weak var backspaceButton: UIButton! {
        didSet {
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)

            let deleteImage = UIImage(systemName: "delete.left.fill", withConfiguration: largeConfig)?.withRenderingMode(.alwaysTemplate)
            backspaceButton.setImage(deleteImage, for: .normal)
            backspaceButton.setTitle("", for: .normal)
            backspaceButton.backgroundColor = .systemGreen
            backspaceButton.tintColor = .black
        }
    }
    @IBOutlet weak var finishedButton: UIButton! {
        didSet {
            finishedButton.backgroundColor = .black
            finishedButton.setTitleColor(.systemGreen, for: .normal)
        }
    }
    @IBOutlet weak var customContainerView: UIView!
    @IBOutlet weak var valueField: UITextField!
    var currentValue = 0
    var currentValueString = "0" {
        didSet {
            valueField.text = currentValueString
            currentValue = Int(currentValueString) ?? 0
        }
    }
    var finished: ((Int) -> Void)?
    var finishedButtonText = "Add"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valueField.text = currentValueString
        finishedButton.setTitle(finishedButtonText, for: .normal)
    }
    
    @IBAction func typeDigit(_ sender: UIButton) {
        let digit = sender.tag
        if currentValueString == "0" {
            currentValueString = "\(digit)"
        } else {
            currentValueString.append("\(digit)")
        }
    }
    
    @IBAction func backspace(_ sender: Any) {
        currentValueString = {
            let newCurrentValue = String(currentValueString.dropLast())
            return newCurrentValue.isEmpty ? "0" : newCurrentValue
        }()
    }

    @IBAction func finished(_ sender: Any) {
        finished?(currentValue)
        dismiss(animated: true, completion: nil)
    }
}

extension KeypadViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
