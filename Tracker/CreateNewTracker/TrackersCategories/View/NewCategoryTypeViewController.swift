//
//  NewCategoryTypeViewController.swift
//  Tracker
//
//  Created by Admin on 22.02.2024.
//

import UIKit

final class NewCategoryTypeViewController: UIViewController {
    
    weak var delegate: NewCategoryTypeViewControllerDelegate?
    
    private lazy var inputNewCategoryTextField: UITextField = {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 30))
        textField.leftViewMode = .always
        let inputNewCategoryTextFieldPlaceholder = NSLocalizedString("inputNewCategoryTextFieldPlaceholder", comment: "")
        textField.placeholder = inputNewCategoryTextFieldPlaceholder
        textField.backgroundColor = .ypBackground.withAlphaComponent(0.3)
        textField.layer.cornerRadius = 16
        textField.clearButtonMode = .whileEditing
        textField.clipsToBounds = true
        textField.becomeFirstResponder()
        textField.returnKeyType = .done
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var creatButton: UIButton = {
        let button = UIButton()
        let creatButtonTitle = NSLocalizedString("creatButton.title", comment: "")
        button.setTitle(creatButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(creatButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        inputNewCategoryTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc
    private func creatButtonTapped() {
        guard let newCategoryTypeText = inputNewCategoryTextField.text, !newCategoryTypeText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        delegate?.addNewCategoryType(with: newCategoryTypeText)
        dismiss(animated: true)
    }
    
    //MARK: - check if the text field is empty after entering each character
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        if let newCategoryType = textField.text {
            if newCategoryType.count == 0 || newCategoryType.first == " " {
                creatButton.backgroundColor = .gray
                creatButton.setTitleColor(.white, for: .normal)
                creatButton.isEnabled = false
            } else {
                creatButton.backgroundColor = .black
                creatButton.setTitleColor(.white, for: .normal)
                creatButton.isEnabled = true
            }
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(inputNewCategoryTextField)
        view.addSubview(creatButton)
        
        NSLayoutConstraint.activate([
            inputNewCategoryTextField.heightAnchor.constraint(equalToConstant: 75),
            inputNewCategoryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            inputNewCategoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            inputNewCategoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            creatButton.heightAnchor.constraint(equalToConstant: 60),
            creatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            creatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            creatButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
}

extension NewCategoryTypeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            creatButton.backgroundColor = .gray
            creatButton.setTitleColor(.white, for: .normal)
        }
    }
}
