//
//  SettingViewController.swift
//  ShotClock
//
//  Created by Nobuhiro Harada on 2019/10/16.
//  Copyright © 2019 Nobuhiro Harada. All rights reserved.
//

import UIKit
 
final class SettingViewController: UIViewController {
    
    private let tableSections: Array = [" ", " ", " ", " "]
    private let tableRowTitles: Array = [
        ["setting_auto_buzzer".localized],
        ["setting_color".localized],
        ["setting_reset".localized],
        ["app_version".localized]
    ]
    private let tableCellId: String = "Cell"
    
    private var tableView: UITableView!
    public var shotClockView: ShotClockView = ShotClockView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        let navbarHeight: CGFloat = self.getNavbarHeight()

        let navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: width, height: navbarHeight))
        
        let navItem = UINavigationItem(title: "setting_view_title".localized)
        
        let closeBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: nil, action: #selector(close(_:)))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            navItem.rightBarButtonItem = closeBtn
        case .pad:
            navItem.title = ""
            navItem.leftBarButtonItem = closeBtn
        default:
            break // do nothing
        }
        
        
        navigationBar.setItems([navItem], animated: true)
        self.view.addSubview(navigationBar)

        tableView = UITableView(frame: CGRect(x: 0, y: navbarHeight, width: width, height: height))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableCellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        
        self.view.addSubview(tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func orientationDidChange(_ notification: NSNotification) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getNavbarHeight() -> CGFloat {
        
        var height = 49.0
        if UIDevice.current.userInterfaceIdiom == .phone {
//            if isIphoneX && !isLandscape {
//                height = 44.0
//                print(123)
//            } else {
//                height = 30.0
//                print(456)
//            }
            if isLandscape {
                height = 30.0
            } else {
                height = 44.0
            }
            
        }
        
        return CGFloat(height)
    }
    
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableRowTitles[section].count
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableSections[section]
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: tableCellId, for: indexPath)
        
        switch indexPath.section {
        case 0: // セクション 1
            switch indexPath.row {
            case 0: // 自動ブザー
                let switchView = UISwitch(frame: .zero)

                if userdefaults.bool(forKey: BUZEER_AUTO_BEEP) {
                    switchView.setOn(true, animated: true)
                } else {
                    switchView.setOn(false, animated: true)
                }

                switchView.tag = indexPath.row // for detect which row switch Changed
                switchView.addTarget(self, action: #selector(self.switchAutoBuzzer(_:)), for: .valueChanged)
                
                if UIDevice.current.userInterfaceIdiom == .phone {
                    cell.accessoryView = switchView
                } else {
                    switchView.center = CGPoint(x: self.view.frame.width - 50, y: cell.frame.height/2)
                    cell.contentView.addSubview(switchView)
                }
                
                cell.textLabel?.text = tableRowTitles[indexPath.section][indexPath.row]
                cell.selectionStyle = .none
                return cell
            default:
                break
            }
        case 1: // セクション2
            switch indexPath.row { // ショットクロック色設定
            case 0:
                if cell.detailTextLabel == nil {
                    cell = UITableViewCell(style: .value1, reuseIdentifier: tableCellId)
                }
                cell.textLabel?.text = tableRowTitles[indexPath.section][indexPath.row]
                if UIDevice.current.userInterfaceIdiom == .phone {
                    cell.detailTextLabel?.text = shotClockView.shotClockLabel.getTextColorString()
                    cell.accessoryType = .disclosureIndicator
                } else {
                    let colorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
                    colorLabel.center = CGPoint(x: self.view.frame.width - 50, y: cell.frame.height/2)
                    colorLabel.textAlignment = .center
                    colorLabel.text = shotClockView.shotClockLabel.getTextColorString()
                    colorLabel.textColor = .systemGray
                    cell.contentView.addSubview(colorLabel)
                }
                
                return cell
            default:
                break
            }
        case 2: // セクション3
            switch indexPath.row { // リセット
            case 0:
                cell.textLabel?.text = tableRowTitles[indexPath.section][indexPath.row]
                cell.textLabel?.textColor = .systemBlue
                return cell
            default:
                break
            }
        case 3: // セクション4
            switch indexPath.row { // バージョン
            case 0:
                if cell.detailTextLabel == nil {
                    cell = UITableViewCell(style: .value1, reuseIdentifier: tableCellId)
                }
                cell.textLabel?.text = tableRowTitles[indexPath.section][indexPath.row]
                cell.selectionStyle = .none
                
                if UIDevice.current.userInterfaceIdiom == .phone {
                    cell.detailTextLabel?.text = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "Unknown"
                } else {
                    let vesionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
                    vesionLabel.center = CGPoint(x: self.view.frame.width - 50, y: cell.frame.height/2)
                    vesionLabel.textAlignment = .center
                    vesionLabel.text = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "Unknown"
                    vesionLabel.textColor = .systemGray
                    cell.contentView.addSubview(vesionLabel)
                }
                
                return cell
            default:
                break
            }
        
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1  && indexPath.row == 0 { // ショットクロックの色設定
            let indexPosition = IndexPath(row: 0, section: 1)
            AlertDialog.showColorSettingActionSheet(shotClockView, tableView, indexPosition, viewController: self)
        }
        else if indexPath.section == 2 && indexPath.row == 0 { // リセット
            self.shotClockView.reset()
            self.dismiss(animated: true, completion: nil)
        }
    }

    @objc func switchAutoBuzzer(_ sender : UISwitch!){

        if sender.isOn {
            userdefaults.set(true, forKey: BUZEER_AUTO_BEEP)
        } else {
            userdefaults.set(false, forKey: BUZEER_AUTO_BEEP)
        }
    }
}
