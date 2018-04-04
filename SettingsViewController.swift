//
//  SettingsVC.swift
//  DarkSkyApp
//
//  Created by Borut on 24/03/2018.
//  Copyright © 2018 Borut. All rights reserved.
//

import UIKit

protocol SettingsControllerDataDelegate: class {
    func sendBlurAndShowSearchBar(intForAlpha: CGFloat,boolShowSearchBar: Bool)
    func sendMetricOrImperial(trueOrFalse: Bool)
    func showOrRemoveCondions(sendString: String)
    func sendLatLongCity(lat: String, long: String)
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableViewSettings: UITableView!
    @IBOutlet weak var btnDone: UIButton!
    
    var listUnits = [String]()
    weak var delegate: SettingsControllerDataDelegate?
    var selectedIndex: Int?
    var citiesTable = [CitiesData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        listUnits = ["Metric", "Imperial"]
        tableViewSettings.backgroundColor = .clear
        tableViewSettings.separatorStyle = .none
        btnDone.layer.cornerRadius = btnDone.frame.size.width/6
        btnDone.clipsToBounds = true
        self.tableViewSettings.reloadData()
        citiesTable = CoreDataHandler.fetchObject()
    }
    
    @IBAction func btnDonePressed(_ sender: Any) {
        delegate?.sendBlurAndShowSearchBar(intForAlpha: 0.0, boolShowSearchBar: false)
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func btnChangeConditionState(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        if sender.tag == 10 {
            if sender.isSelected == true {
                delegate?.showOrRemoveCondions(sendString: conditionsData.hideHumidity)
            }
            else {
                delegate?.showOrRemoveCondions(sendString: conditionsData.showHumidity)
            }
            UserDefaults.standard.set(sender.isSelected, forKey: "checkMarkHumidity")
        }
        if sender.tag == 20 {
            if sender.isSelected == true {
                delegate?.showOrRemoveCondions(sendString: conditionsData.hideWind)
            }
            else {
                delegate?.showOrRemoveCondions(sendString: conditionsData.showWind)
            }
            UserDefaults.standard.set(sender.isSelected, forKey: "checkmarkWind")
        }
        if sender.tag == 30 {
            if sender.isSelected == true {
                delegate?.showOrRemoveCondions(sendString: conditionsData.hidePressure)
            }
            else {
                delegate?.showOrRemoveCondions(sendString: conditionsData.showPressure)
            }
            UserDefaults.standard.set(sender.isSelected, forKey: "checkmarkPressure")
        }
    }
}
//MARK: extension for table view
extension SettingsViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Units"
        }
        else if section == 2 {
            return "Conditions"
        }
        return "Location"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return citiesTable.count
        }
        else if section == 1 {
            return listUnits.count
        }
        return 1
    }
    //FIXME: fix userDefault for checkmarks
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableViewSettings.dequeueReusableCell(withIdentifier: "locationCell") as! LocationsTableViewCell
            cell.lblLocations.text = citiesTable[indexPath.row].cityName
            cell.backgroundColor = .clear
            //cell.btnChecked.addTarget(self, action: #selector(checkMarkBtnClicked(sender:)), for: .touchUpInside)
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableViewSettings.dequeueReusableCell(withIdentifier: "unitsCell") as! UnitsTableViewCell
            cell.lblUnits.text = listUnits[indexPath.row]
            cell.backgroundColor = .clear
            if indexPath.row == selectedIndex {
                cell.btnChecked.setBackgroundImage(UIImage(named: "square_checkmark_check"), for: UIControlState.normal)
            }
            else {
                cell.btnChecked.setBackgroundImage(UIImage(named: "square_checkmark_uncheck"), for: UIControlState.normal)
            }
            return cell
        }
        else {
            let cell = tableViewSettings.dequeueReusableCell(withIdentifier: "conditionCell") as! ConditionsTableViewCell
            cell.backgroundColor = .clear
            if let dataHumidity = UserDefaults.standard.object(forKey: "checkMarkHumidity") {
                cell.btnCheckMarkHumidity.isSelected = dataHumidity as! Bool
            }
            if let dataWind = UserDefaults.standard.object(forKey: "checkmarkWind") {
                cell.btnCheckMarkWind.isSelected = dataWind as! Bool
            }
            if let dataPressure = UserDefaults.standard.object(forKey: "checkmarkPressure") {
                cell.btnCheckMarkPressure.isSelected = dataPressure as! Bool
            }
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 200
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textAlignment = .center
            headerView.backgroundView?.backgroundColor = .clear
            headerView.textLabel?.textColor = .white
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewSettings.backgroundColor = .clear
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        if indexPath.section == 0 {
            let citiesSelected = citiesTable[indexPath.row]
            delegate?.sendLatLongCity(lat: citiesSelected.latitude!, long: citiesSelected.longitude!)
        }
        if indexPath.section == 1 {
            if selectedIndex == 0 {
                delegate?.sendMetricOrImperial(trueOrFalse: true)
            }
            else if selectedIndex == 1 {
                delegate?.sendMetricOrImperial(trueOrFalse: false)
            }
            tableViewSettings.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && editingStyle == UITableViewCellEditingStyle.delete{
                CoreDataHandler.deleteObject(city: citiesTable[indexPath.row])
                citiesTable.remove(at: indexPath.row)
                tableViewSettings.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }
}
