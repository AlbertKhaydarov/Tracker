//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 21.02.2024.
//

import UIKit

final class OnboardingPageViewController: UIViewController {
    
    weak var delegate: OnboardingPageViewControllerDelegate?
    var currentPageIndex: Int = 0
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .ypBold32
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitle("Вот это технологии!", for: .normal)
        button.setTitleColor( .ypWhite, for: .normal)
        button.titleLabel?.font = .ypMedium16
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(button)
        return stackView
    }()
    
    init(imageName: String, titleText: String) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = UIImage(named: imageName)
        titleLabel.text = titleText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        style()
        layout()
    }
    
    @objc private func buttonTapped () {
        delegate?.switchToMainPage()
        UserDefaultsStorage.shared.isFirstLaunch = false
    }
    
    private func style() {
        view.addSubview(imageView)
        view.addSubview(stackView)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            
            titleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -160),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            button.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])
    }
}
