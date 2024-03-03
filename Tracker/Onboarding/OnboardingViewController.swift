//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 21.02.2024.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    private let totalPages = 2
    private var imageNames: [String] = []
    private var titles: [String] = []
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = totalPages
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .black.withAlphaComponent(0.3)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: options)
        dataSource = self
        delegate = self

        imageNames = ["page1", "page2"]
        titles = ["Отслеживайте только\nто, что хотите", "Даже если это\nне литры воды и йога"]
        
        setViewControllers([creatPageViewController(at: 0)],
                           direction: .forward,
                           animated: true,
                           completion: nil)
        
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func creatPageViewController(at index: Int) -> OnboardingPageViewController {
        var newViewController: OnboardingPageViewController
        if index == 0 {
            newViewController = OnboardingPageViewController(imageName: imageNames[index], titleText: titles[index])
        } else {
            newViewController = OnboardingPageViewController(imageName: imageNames[index], titleText: titles[index])
        }
        newViewController.currentPageIndex = index
        newViewController.delegate = self
        return newViewController
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageContent: OnboardingPageViewController = viewController as? OnboardingPageViewController else {return nil}
        var previousIndex = pageContent.currentPageIndex - 1
        if previousIndex < 0 {
            previousIndex = totalPages - 1
        }
        return creatPageViewController(at: previousIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageContent: OnboardingPageViewController = viewController as? OnboardingPageViewController else {return nil}
        var nextIndex = pageContent.currentPageIndex + 1
        if nextIndex > totalPages - 1  {
            nextIndex = 0
        }
        return creatPageViewController(at: nextIndex)
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentViewController = viewControllers?[0] as? OnboardingPageViewController
        else { return }
        let currentIndex = currentViewController.currentPageIndex
        pageControl.currentPage = currentIndex
    }
}

extension OnboardingViewController: OnboardingPageViewControllerDelegate {
    func switchToMainPage() {
        let tabBarController = TabBarController()
        if let window = UIApplication.shared.windows.first {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = tabBarController
            }, completion: nil)
            window.makeKeyAndVisible()
        }
    }
}
