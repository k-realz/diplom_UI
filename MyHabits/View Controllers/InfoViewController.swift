//
//  InfoViewController.swift
//  MyHabits
//
//  Created by Kirill Komov on 11.08.2021.
//

import UIKit

class InfoViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    
    private let infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычка за 21 день"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Прохождение этапов, за которые за 21 день вырабатывается привычка, подчиняется следующему алгоритму:"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "1. Провести 1 день без обращения к старым привычкам, стараться вести себя так, как будто цель, загаданная в перспективу, находится на расстоянии шага.\n\n2. Выдержать 2 дня в прежнем состоянии самоконтроля. \n\n3. Отметить в дневнике первую неделю изменений и подвести первые итоги — что оказалось тяжело, что — легче, с чем еще предстоит серьезно бороться.\n\n4. Поздравить себя с прохождением первого серьезного порога в 21 день. За это время отказ от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств. \n\n5. Держать планку 40 дней. Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой. \n\n6. На 90-й день соблюдения техники все лишнее из «прошлой жизни» перестает напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновившимся."
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let advicesStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Информация"
        self.view.backgroundColor = .white
        
        setupViews()
    }
    
    private func setupViews() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(infoView)
        infoView.addSubviews(headerLabel, advicesStack)
        advicesStack.addArrangedSubview(infoLabel)
        advicesStack.addArrangedSubview(textLabel)
    
        let constraints = [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            infoView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            infoView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            infoView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            infoView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            headerLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 22),
            headerLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: sideInset),
            headerLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -141),
            
            advicesStack.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: sideInset),
            advicesStack.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: sideInset),
            advicesStack.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -sideInset),
            advicesStack.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -22)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
   
    private var sideInset: CGFloat { return 16 }
}


