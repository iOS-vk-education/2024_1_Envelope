//
//  MoodPickerViewDelegate.swift
//  TwiX
//
//  Created by Alexander on 24.12.2024.
//

protocol MoodPickerViewDelegate: AnyObject {
    func moodPickerView(_ pickerView: MoodPickerView, didSelectMoods moods: [Mood])
}
