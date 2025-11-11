//
//  OnboardingContainerViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

protocol OnboardingContainerViewControllerDelegate: AnyObject {
    func goToAllPatient()
}

class OnboardingContainerViewController: UIViewController {
    
    weak var delegateOnboarding: OnboardingContainerViewControllerDelegate?
    
    private let pageController: UIPageViewController
    private var pages = [UIViewController]()
    private var currentIndex = 0
    
    private let nextButton = StandardConfirmationButton(title: "Próximo")
    private let pageControl = UIPageControl()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Voltar", for: .normal)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .teal10
        button.setTitleColor(.teal10, for: .normal)
        button.alpha = 0
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Pular", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.teal10, for: .normal)
        return button
    }()
    
    init() {
        self.pageController = UIPageViewController(transitionStyle: .scroll,
                                                   navigationOrientation: .horizontal,
                                                   options: nil)
        super.init(nibName: nil, bundle: nil)
        
        let page1 = OnboardingPageViewController(imageName: "onboarding1", title: "Sem mais bagunça", description: "Gerencie necessidades básicas, medicamentos, tarefas, ocorrências, tudo em um só lugar")
        let page2 = OnboardingPageViewController(imageName: "onboarding2", title: "Conexão é a chave", description: "Compartilhe o perfil do paciente com familiares e outros cuidadores")
        let page3 = OnboardingPageViewController(imageName: "onboarding3", title: "Relatórios mostram o que importa", description: "Acompanhe as atividades de atendimento e obtenha insights claros dos relatórios dos pacientes", imageHeightMultiplier: 0.6)

        pages = [page1, page2, page3]
        pageController.dataSource = self
        pageController.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupPageController()
        setupUI()
    }
    
    private func setupPageController() {
        addChild(pageController)
        view.addSubview(pageController.view)
        pageController.didMove(toParent: self)
        
        if let first = pages.first {
            pageController.setViewControllers([first], direction: .forward, animated: true)
        }
    }
    
    private func setupUI() {
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .teal10
        pageControl.pageIndicatorTintColor = .teal10.withAlphaComponent(0.3)
        pageControl.isUserInteractionEnabled = false
        
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        
        let navStack = UIStackView(arrangedSubviews: [backButton, pageControl, skipButton])
        navStack.axis = .horizontal
        navStack.alignment = .center
        navStack.distribution = .equalCentering
        
        view.addSubview(navStack)
        navStack.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomStack = UIStackView(arrangedSubviews: [nextButton])
        bottomStack.axis = .vertical
        bottomStack.alignment = .center
        
        view.addSubview(bottomStack)
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Layout.mediumSpacing),
            navStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            navStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pageControl.centerXAnchor.constraint(equalTo: navStack.centerXAnchor),
            
            bottomStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Layout.smallButtonBottomPadding),
            bottomStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 215),
            nextButton.heightAnchor.constraint(equalToConstant: 46)
        ])
    }
    
    @objc private func nextTapped() {
        if currentIndex < pages.count - 1 {
            currentIndex += 1
            let nextVC = pages[currentIndex]
            pageController.setViewControllers([nextVC], direction: .forward, animated: true)
            pageControl.currentPage = currentIndex
            
            let shouldShowBack = currentIndex > 0
            UIView.animate(withDuration: 0.25) {
                self.backButton.alpha = shouldShowBack ? 1 : 0
            }
            backButton.isUserInteractionEnabled = shouldShowBack
            
            nextButton.updateTitle(currentIndex == pages.count - 1 ? "Começar" : "Próximo")
        } else {
            delegateOnboarding?.goToAllPatient()
        }
    }
    
    @objc private func backTapped() {
        if currentIndex > 0 {
            currentIndex -= 1
            let prevVC = pages[currentIndex]
            pageController.setViewControllers([prevVC], direction: .reverse, animated: true)
            pageControl.currentPage = currentIndex
            
            let shouldShowBack = currentIndex > 0
            UIView.animate(withDuration: 0.25) {
                self.backButton.alpha = shouldShowBack ? 1 : 0
            }
            backButton.isUserInteractionEnabled = shouldShowBack
            
            nextButton.updateTitle("Próximo")
        }
    }
    
    
    @objc private func skipTapped() {
        delegateOnboarding?.goToAllPatient()
    }
}

extension OnboardingContainerViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else { return nil }
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if completed, let visibleVC = pageViewController.viewControllers?.first,
           let index = pages.firstIndex(of: visibleVC) {
            currentIndex = index
            pageControl.currentPage = index
            
            let shouldShowBack = currentIndex > 0
            UIView.animate(withDuration: 0.25) {
                self.backButton.alpha = shouldShowBack ? 1 : 0
            }
            backButton.isUserInteractionEnabled = shouldShowBack
            
            nextButton.updateTitle(index == pages.count - 1 ? "Começar" : "Próximo")
        }
    }
    
}
