//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Kirill Komov on 11.08.2021.
//

import UIKit


class HabitViewController: UIViewController {
   
    var habit: Habit? {
        didSet {
            editHabit()
        }
    }
    
    private let scrollView = UIScrollView()
    
    private let habitView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func subStackView(stackView: UIStackView, title: UIView, object: UIView) {
        let subStackView = UIStackView()
        subStackView.axis = .vertical
        subStackView.alignment = .leading
        subStackView.distribution = .fill
        subStackView.spacing = 7
        subStackView.translatesAutoresizingMaskIntoConstraints = false
        subStackView.addArrangedSubview(title)
        subStackView.addArrangedSubview(object)
        stackView.addArrangedSubview(subStackView)
    }
    
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "НАЗВАНИЕ"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let habitTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .black
        textField.layer.borderColor = UIColor.white.cgColor
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        textField.returnKeyType = UIReturnKeyType.done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let colorLabel: UILabel = {
        let label = UILabel()
        label.text = "ЦВЕТ"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let colorButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.backgroundColor = .orange
        button.addTarget(self, action: #selector(tapColorButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func tapColorButton() {
        
        let colorPicker = UIColorPickerViewController()
        colorPicker.selectedColor = self.colorButton.backgroundColor!
        colorPicker.delegate = self
        self.present(colorPicker, animated: true, completion: nil)
    }
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "ВРЕМЯ"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
   
    private let timePickerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

   
   
    private let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .time
        picker.addTarget(self, action: #selector (selectTime), for: .valueChanged)
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    
    
    @objc func selectTime(){
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        let textStr = NSMutableAttributedString(string: "Каждый день в ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)])
        let selectedTime = formatter.string(from: timePicker.date)
        let dateStr = NSAttributedString(string: selectedTime, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.purpleTheme!])
        textStr.append(dateStr)
        timePickerLabel.attributedText = textStr
    }
    
    
    
    private let removeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(UIColor.redTheme, for: .normal)
        button.addTarget(self, action: #selector(showAlertController), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func showAlertController() {
        
        guard let habitToRemove = habit else { return }
        let alertController = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку \"\(habitToRemove.name)\"?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        let confirm = UIAlertAction(title: "Удалить", style: .default) { (action:UIAlertAction) in
            self.removeHabit()
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancel)
        alertController.addAction(confirm)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func removeHabit() {
        HabitsStore.shared.habits.removeAll{$0 == self.habit}
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goToHabitsVC"), object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editHabit()
        setupNavigation()
        selectTime()
        setupViews()
        habitTextField.delegate = self
    }
    
    func setupNavigation() {
        
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = UIColor.purpleTheme
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(returnBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveAndReturn))
    }
    
    @objc func returnBack() {
    self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func saveAndReturn() {
        if let changedHabit = self.habit {
            changedHabit.name = habitTextField.text ?? ""
            changedHabit.date = timePicker.date
            changedHabit.color = colorButton.backgroundColor ?? .white
            HabitsStore.shared.save()
        } else {
            let newHabit = Habit(name: habitTextField.text ?? "",
                                 date: timePicker.date,
                                 color: colorButton.backgroundColor ?? .white)
            
            let store = HabitsStore.shared
            store.habits.append(newHabit)
            print(store.habits.count)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTitle"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    

 
    func setupViews() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollView.addSubviews(habitView, stackView, removeButton)
        
        subStackView(stackView: stackView, title: nameLabel, object: habitTextField)
        subStackView(stackView: stackView, title: colorLabel, object: colorButton)
        subStackView(stackView: stackView, title: timeLabel, object: timePickerLabel)
        stackView.addArrangedSubview(timePicker)
        
        
        
        let constraints = [
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            habitView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            habitView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            habitView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            habitView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            habitView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: habitView.topAnchor, constant: 21),
            stackView.leadingAnchor.constraint(equalTo: habitView.leadingAnchor, constant: sideInset),
            stackView.trailingAnchor.constraint(equalTo: habitView.trailingAnchor, constant: -sideInset),
            
            removeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            removeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -18),
            
            colorButton.widthAnchor.constraint(equalToConstant: 30),
            colorButton.heightAnchor.constraint(equalToConstant: 30)
            
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func editHabit() {
        if let changedHabit = habit {
            habitTextField.text = changedHabit.name
            habitTextField.textColor = changedHabit.color
            habitTextField.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            colorButton.backgroundColor = changedHabit.color
            timePicker.date = changedHabit.date
            navigationItem.title = "Править"
            removeButton.isHidden = false
        }
        else {
            habitTextField.text  = ""
            colorButton.backgroundColor = UIColor.orangeTheme
            timePicker.date = Date()
            navigationItem.title = "Создать"
            removeButton.isHidden = true
        }
    }
    
    private var sideInset: CGFloat { return 16 }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc fileprivate func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
}

extension  HabitViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension HabitViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.colorButton.backgroundColor = viewController.selectedColor
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        self.colorButton.backgroundColor = viewController.selectedColor
    }
}
