//
//  MoodPickerView.swift
//  TwiX
//
//  Created by Alexander on 24.12.2024.
//

import UIKit

class MoodPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    weak var delegate: MoodPickerViewDelegate?
    private var selectedMoods: [Mood] = []
    private let maxSelectionCount = 3
    
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addSubview(containerView)
        containerView.addSubview(pickerView)
        containerView.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            containerView.heightAnchor.constraint(equalToConstant: 300),
            
            pickerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            pickerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            doneButton.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 8),
            doneButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    func showPicker(from parent: UIViewController, selectedMoods: [Mood]) {
        self.selectedMoods = selectedMoods
        frame = parent.view.bounds
        parent.view.addSubview(self)
    }
    
    @objc
    private func doneTapped() {
        removeFromSuperview()
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Mood.allCases.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Mood.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedMood = Mood.allCases[row]
        if selectedMoods.contains(selectedMood) {
            selectedMoods.removeAll { $0 == selectedMood }
        } else if selectedMoods.count < maxSelectionCount {
            selectedMoods.append(selectedMood)
        }
        delegate?.moodPickerView(self, didSelectMoods: selectedMoods)
    }
}
