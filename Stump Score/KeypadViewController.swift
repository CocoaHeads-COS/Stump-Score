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
                $0.backgroundColor = .white
                $0.setTitleColor(.black, for: .normal)
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
            backspaceButton.backgroundColor = .white
            backspaceButton.tintColor = .black
        }
    }
    @IBOutlet weak var finishedButton: UIButton! {
        didSet {
            finishedButton.backgroundColor = .white
            finishedButton.setTitleColor(.black, for: .normal)
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }
    
    // Need this so that pressesBegan will work, and we can respond to external keyboards
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // Respond to number keys and delete/backspace from external keyboards
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
//        print("Presses began: \(presses) with event \(event)")
        guard presses.count == 1, // Only one press at a time
              let press = presses.first,
              let pressedKey = press.key,
              pressedKey.modifierFlags == [] // No modifiers (shift, ctrl) allowed
        else {
            super.pressesBegan(presses, with: event)
            return
        }
        
        if let numberPressed = Int(pressedKey.characters) {
            // Handle number keys
            print("number pressed: \(numberPressed)")
            handlePressOf(digit: numberPressed)
        } else if pressedKey.keyCode == .keyboardDeleteOrBackspace {
            // Handle backspace/delete
            handleBackspace()
        } else {
            super.pressesBegan(presses, with: event)
        }
    }

    func handlePressOf(digit: Int) -> Void {
        if currentValueString == "0" {
            currentValueString = "\(digit)"
        } else {
            currentValueString.append("\(digit)")
        }
    }
    
    func handleBackspace() -> Void {
        currentValueString = {
            let newCurrentValue = String(currentValueString.dropLast())
            return newCurrentValue.isEmpty ? "0" : newCurrentValue
        }()
    }
    
    @IBAction func typeDigit(_ sender: UIButton) {
        handlePressOf(digit: sender.tag)
    }
    
    @IBAction func backspace(_ sender: Any) {
        handleBackspace()
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
