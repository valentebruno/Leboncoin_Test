//
//  SettingsViewController.swift
//  leboncoinPaperClip
//
//  Created by Bruno Valente on 07/05/25.
//


 import UIKit

class SettingsViewController: UIViewController {
    private let languages = [("fr","Français"),("en","English"),("pt","Português"),("es","Español")]
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("TabSettings", comment: "Settings tab")
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
        languages.count
    }
    func tableView(_ tv: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let (code, name) = languages[indexPath.row]
        cell.textLabel?.text = name
        if Locale.current.languageCode == code {
            cell.accessoryType = .checkmark
        }
        return cell
    }
}

 
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tv: UITableView, didSelectRowAt indexPath: IndexPath) {
        let code = languages[indexPath.row].0
        UserDefaults.standard.set([code], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            exit(0)
        }
    }
}
