//
//  SettingViewController.swift
//  ShotClock
//
//  Created by Nobuhiro Harada on 2019/10/16.
//  Copyright © 2019 Nobuhiro Harada. All rights reserved.
//

import UIKit
 
final class SettingViewController: UIViewController {
    
    private let tableSections: Array = [" ", " ", " "]
    private let tableRowTitles: Array = [
        ["setting_auto_buzzer".localized],
        ["setting_reset".localized],
        ["app_version".localized]
    ]
    private let tableCellId: String = "Cell"
    private let colorCollectionCellId: String = "ColorCollectionCell"
    
    private var tableView: UITableView!
    
    private let colorArray: [UIColor] = [
        .yellow, .red, .green, .white, .systemBlue, .systemIndigo, .systemOrange, .systemPink, .systemTeal
    ]
    private var colorCollectionView: UICollectionView!
    private var colorCollectionHeaderView: UIView!
    private var colorCollectionViewTitle: UILabel!
    
    public var shotClockView: ShotClockView!
    
    private var scrollView: UIScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        let viewWidth = self.view.frame.width
        let viewHeight = self.view.frame.height
        
        let closeBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: self, action: #selector(close(_:)))
        
        self.navigationItem.title = "setting_view_title".localized
        self.navigationItem.leftBarButtonItem = closeBtn
        
        let barHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        scrollView.frame = CGRect(x: 0, y: barHeight, width: viewWidth, height: viewHeight)
        scrollView.contentSize = CGSize(width: viewWidth, height: viewHeight*1.2)
        scrollView.backgroundColor = .systemBackground
        scrollView.isScrollEnabled = true
        self.view.addSubview(scrollView)

        colorCollectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: 28))
        colorCollectionHeaderView.backgroundColor = .systemGray4
        
        self.scrollView.addSubview(colorCollectionHeaderView)
        
        let colorCollectionViewTitlePosX: CGFloat = shotClockView.getColorCollectionViewTitlePosX()
        
        colorCollectionViewTitle = UILabel(frame: CGRect(x: colorCollectionViewTitlePosX, y: 4, width: 200, height: 21))
        colorCollectionViewTitle.textColor = .label
        colorCollectionViewTitle.text = "setting_shotclock_color".localized
        colorCollectionViewTitle.font = .systemFont(ofSize: 14.0)
        
        colorCollectionHeaderView.addSubview(colorCollectionViewTitle)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 36, height: 36)
        layout.sectionInset = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        
        let colorCollctionViewHeight: CGFloat = shotClockView.getColorCollectionViewHeight()
        
        let colorCollectionViewPosX: CGFloat = shotClockView.getColorCollectionViewPosX()
        
        colorCollectionView = UICollectionView(frame: CGRect(x: colorCollectionViewPosX, y:  colorCollectionHeaderView.frame.height, width: viewWidth, height: colorCollctionViewHeight), collectionViewLayout: layout)
        colorCollectionView.collectionViewLayout = layout
        
        colorCollectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: colorCollectionCellId)

        colorCollectionView.backgroundColor = .systemBackground

        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        
        self.scrollView.addSubview(colorCollectionView)
        
        tableView = UITableView(frame:
            CGRect(x: 0,
                   y: colorCollectionHeaderView.frame.height + colorCollectionView.frame.height,
                   width: viewWidth,
                   height: colorCollectionHeaderView.frame.height + colorCollectionView.frame.height + viewHeight))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableCellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = true
        
        self.scrollView.addSubview(tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func close(_ sender: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func orientationDidChange(_ notification: NSNotification) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - ColorColletionView Delegate, Datasource
extension SettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell: ColorCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: colorCollectionCellId, for: indexPath) as? ColorCollectionViewCell {

            cell.contentView.layer.backgroundColor = colorArray[indexPath.row].cgColor
            
            if colorArray[indexPath.row] == .white {
                cell.contentView.layer.borderWidth = 1
                cell.contentView.layer.borderColor = UIColor.gray.cgColor
            }
            
            if colorArray[indexPath.row] == shotClockView.shotClockLabel.getCurrentShotClockTextColor() {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                cell.selectedColor()
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let selectedCell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
            selectedCell.selectedColor()
        }

        switch indexPath.row {
        case 0:
            shotClockView.shotClockLabel.textColor = .yellow
            userdefaults.setShotClockColor(.yellow, forKey: SHOT_CLOCK_COLOR)
        case 1:
            shotClockView.shotClockLabel.textColor = .red
            userdefaults.setShotClockColor(.red, forKey: SHOT_CLOCK_COLOR)
        case 2:
            shotClockView.shotClockLabel.textColor = .green
            userdefaults.setShotClockColor(.green, forKey: SHOT_CLOCK_COLOR)
        case 3:
            shotClockView.shotClockLabel.textColor = .white
            userdefaults.setShotClockColor(.white, forKey: SHOT_CLOCK_COLOR)
        case 4:
            shotClockView.shotClockLabel.textColor = .systemBlue
            userdefaults.setShotClockColor(.systemBlue, forKey: SHOT_CLOCK_COLOR)
        case 5:
            shotClockView.shotClockLabel.textColor = .systemIndigo
            userdefaults.setShotClockColor(.systemIndigo, forKey: SHOT_CLOCK_COLOR)
        case 6:
            shotClockView.shotClockLabel.textColor = .systemOrange
            userdefaults.setShotClockColor(.systemOrange, forKey: SHOT_CLOCK_COLOR)
        case 7:
            shotClockView.shotClockLabel.textColor = .systemPink
            userdefaults.setShotClockColor(.systemPink, forKey: SHOT_CLOCK_COLOR)
        case 8:
            shotClockView.shotClockLabel.textColor = .systemTeal
            userdefaults.setShotClockColor(.systemTeal, forKey: SHOT_CLOCK_COLOR)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
            selectedCell.deselectedColor()
        }
    }
}

// MARK: - TableView Delegate, Datasource
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
            switch indexPath.row { // リセット
            case 0:
                cell.textLabel?.text = tableRowTitles[indexPath.section][indexPath.row]
                cell.textLabel?.textColor = .systemBlue
                return cell
            default:
                break
            }
        case 2: // セクション3
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
        if indexPath.section == 1 && indexPath.row == 0 { // リセット
            self.shotClockView.reset()
            self.dismiss(animated: true, completion: nil)
        }
    }

    @objc func switchAutoBuzzer(_ sender : UISwitch!){
        if sender.isOn {
            userdefaults.set(true, forKey: BUZEER_AUTO_BEEP)
            shotClockView.autoBuzzerLabel.textColor = .white
        } else {
            userdefaults.set(false, forKey: BUZEER_AUTO_BEEP)
            shotClockView.autoBuzzerLabel.textColor = .black
        }
    }
}
