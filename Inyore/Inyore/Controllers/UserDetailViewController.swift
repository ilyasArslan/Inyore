//
//  UserDetailViewController.swift
//  Inyore
//
//  Created by Arslan on 05/10/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit
import DropDown

class UserDetailViewController: UIViewController {

    //MARK: Outlets
    
    @IBOutlet weak var txtIncome: CustomTextField!
    @IBOutlet weak var btnIncome: UIButton!
    var incomeId = ""
    
    @IBOutlet weak var txtIndustry: CustomTextField!
    @IBOutlet weak var btnIndustry: UIButton!
    var industryId = ""
    
    @IBOutlet weak var txtCountry: CustomTextField!
    @IBOutlet weak var btncountry: UIButton!
    var countryId = ""
    
    @IBOutlet weak var txtState: CustomTextField!
    @IBOutlet weak var btnState: UIButton!
    var stateId = ""
    
    @IBOutlet weak var btnFounder: UIButton!
    @IBOutlet weak var btnC_Suite: UIButton!
    @IBOutlet weak var btnExecutiveLevel: UIButton!
    @IBOutlet weak var btnDirectorLevel: UIButton!
    @IBOutlet weak var btnManagment: UIButton!
    @IBOutlet weak var btnExperience7: UIButton!
    @IBOutlet weak var btnExperience5_7: UIButton!
    @IBOutlet weak var btnExperience3_7: UIButton!
    @IBOutlet weak var btnEntryLevel: UIButton!
    var departmentId = ""
    
    @IBOutlet weak var btnBaboomery: UIButton!
    @IBOutlet weak var btnGenX: UIButton!
    @IBOutlet weak var btnMillenial: UIButton!
    @IBOutlet weak var btnGenZ: UIButton!
    var generationId = ""
    
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnTransgender: UIButton!
    @IBOutlet weak var btnTransgenderFemale: UIButton!
    @IBOutlet weak var btnAgender: UIButton!
    @IBOutlet weak var btnOther: UIButton!
    var genderId = ""
    
    @IBOutlet weak var btnAmericanIndian: UIButton!
    @IBOutlet weak var btnAsian: UIButton!
    @IBOutlet weak var btnBlackAfrican: UIButton!
    @IBOutlet weak var btnHispanic: UIButton!
    @IBOutlet weak var btnNativeHawaiian: UIButton!
    @IBOutlet weak var btnWhite: UIButton!
    @IBOutlet weak var btnRaceOther: UIButton!
    var raceId = ""
    
    @IBOutlet weak var txtCompany: CustomTextField!
    
    var myUser: [User]? {didSet {}}
    
    var arrIncomes = [incomes]()
    
    var arrDepartments = [departments]()
    var arrGeneration = [generations]()
    var arrGender = [genders]()
    var arrRace = [races]()
    
    var arrIndustries = [industries]()
    var arrCountries = [countries]()
    var arrStates = [states]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    //MARK:- Setup View
    func setupView() {
        
        self.callBeHeardAPI()
    }
    
    //MARK:- Utility Methods
    
    //MARK:- Button Action
    
    @IBAction func btnJobDropDownAction(_ sender: UIButton) {
        
        let dropDown = DropDown()

        dropDown.anchorView = self.btnIncome
        dropDown.semanticContentAttribute = .unspecified
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        for income in arrIncomes{
            let name = income.ic_name!
            dropDown.dataSource.append(name)
        }
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.incomeId = "\(self.arrIncomes[index].id!)"
            print("Income Id: ", self.incomeId)
            self.txtIncome.text = item
            
        }
        
        dropDown.direction = .bottom
        dropDown.show()
    }
    
    @IBAction func btnIndustruDropDownAction(_ sender: UIButton) {
        
        let dropDown = DropDown()

        dropDown.anchorView = self.btnIndustry
        dropDown.semanticContentAttribute = .unspecified
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        for industry in arrIndustries{
            let name = industry.in_name!
            dropDown.dataSource.append(name)
        }
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.industryId = "\(self.arrIndustries[index].id!)"
            print("Industry Id: ", self.industryId)
            self.txtIndustry.text = item
            
        }
        
        dropDown.direction = .bottom
        dropDown.show()
        
    }
    
    @IBAction func btnCountryDropDownAction(_ sender: UIButton) {
        
        let dropDown = DropDown()

        dropDown.anchorView = self.btncountry
        dropDown.semanticContentAttribute = .unspecified
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        for country in arrCountries{
            let name = country.ct_name!
            dropDown.dataSource.append(name)
        }
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.countryId = "\(self.arrCountries[index].id!)"
            print("Country Id: ", self.countryId)
            self.txtCountry.text = item
            
        }
        
        dropDown.direction = .top
        dropDown.show()
    }
    
    @IBAction func btnStateDropDownAction(_ sender: UIButton) {
        
        let dropDown = DropDown()

        dropDown.anchorView = self.btnState
        dropDown.semanticContentAttribute = .unspecified
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        for state in arrStates{
            let id = "\(state.st_country_id!)"
            let name = state.st_name!
            
            if self.countryId == id{
                dropDown.dataSource.append(name)
            }
            
        }
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.stateId = "\(self.arrStates[index].id!)"
            print("State Id: ", self.stateId)
            self.txtState.text = item
            
        }
        
        dropDown.direction = .top
        dropDown.show()
    }
    
    @IBAction func btnJobLevelAction(_ sender: UIButton) {
        
        if sender.tag == 0{
            
            self.btnFounder.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            self.btnC_Suite.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExecutiveLevel.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnDirectorLevel.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnManagment.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExperience7.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExperience5_7.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExperience3_7.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnEntryLevel.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            
            self.departmentId = "\(self.arrDepartments[sender.tag].id!)"
        }
        else if sender.tag == 1{
            
            self.btnFounder.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnC_Suite.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            self.btnExecutiveLevel.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnDirectorLevel.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnManagment.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExperience7.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExperience5_7.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExperience3_7.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnEntryLevel.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            
            self.departmentId = "\(self.arrDepartments[sender.tag].id!)"
        }
        else if sender.tag == 2{
            
            self.btnFounder.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnC_Suite.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExecutiveLevel.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            self.btnDirectorLevel.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnManagment.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExperience7.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExperience5_7.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExperience3_7.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnEntryLevel.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            
            self.departmentId = "\(self.arrDepartments[sender.tag].id!)"
        }
        else if sender.tag == 3{
            
            self.btnFounder.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnC_Suite.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExecutiveLevel.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnDirectorLevel.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            self.btnManagment.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExperience7.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExperience5_7.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExperience3_7.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnEntryLevel.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            
            self.departmentId = "\(self.arrDepartments[sender.tag].id!)"
        }
        else if sender.tag == 4{
            
            self.btnFounder.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnC_Suite.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExecutiveLevel.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnDirectorLevel.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnManagment.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            self.btnExperience7.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExperience5_7.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExperience3_7.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnEntryLevel.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            
            self.departmentId = "\(self.arrDepartments[sender.tag].id!)"
        }
        else if sender.tag == 5{
            
            self.btnFounder.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnC_Suite.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExecutiveLevel.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnDirectorLevel.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnManagment.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExperience7.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            self.btnExperience5_7.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExperience3_7.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnEntryLevel.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            
            self.departmentId = "\(self.arrDepartments[sender.tag].id!)"
        }
        else if sender.tag == 6{
            
            self.btnFounder.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnC_Suite.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExecutiveLevel.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnDirectorLevel.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnManagment.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExperience7.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExperience5_7.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            self.btnExperience3_7.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnEntryLevel.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            
            self.departmentId = "\(self.arrDepartments[sender.tag].id!)"
        }
        else if sender.tag == 7{
            
            self.btnFounder.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnC_Suite.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExecutiveLevel.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnDirectorLevel.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnManagment.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExperience7.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExperience5_7.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExperience3_7.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            self.btnEntryLevel.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            
            self.departmentId = "\(self.arrDepartments[sender.tag].id!)"
        }
        else{
            
            self.btnFounder.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnC_Suite.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExecutiveLevel.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnDirectorLevel.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnManagment.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExperience7.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExperience5_7.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnExperience3_7.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnEntryLevel.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            
            self.departmentId = "\(self.arrDepartments[sender.tag].id!)"
        }
    }
    
    @IBAction func btnGenerationAction(_ sender: UIButton) {
        
        if sender.tag == 0{
            
            self.btnBaboomery.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            self.btnGenX.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnMillenial.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnGenZ.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            
            self.generationId = "\(self.arrGeneration[sender.tag].id!)"
            
        }
        else if sender.tag == 1{
            
            self.btnBaboomery.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnGenX.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            self.btnMillenial.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnGenZ.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            
            self.generationId = "\(self.arrGeneration[sender.tag].id!)"
        }
        else if sender.tag == 2{
            
            self.btnBaboomery.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnGenX.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnMillenial.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            self.btnGenZ.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            
            self.generationId = "\(self.arrGeneration[sender.tag].id!)"
        }
        else{
            
            self.btnBaboomery.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnGenX.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnMillenial.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnGenZ.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            
            self.generationId = "\(self.arrGeneration[sender.tag].id!)"
        }

    }
    
    @IBAction func btnGenderAction(_ sender: UIButton) {
        
        if sender.tag == 0{
            
            self.btnMale.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            self.btnFemale.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnTransgender.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnTransgenderFemale.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnAgender.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnOther.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            
            self.genderId = "\(self.arrGender[sender.tag].id!)"
        }
        else if sender.tag == 1{
            
            self.btnMale.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnFemale.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            self.btnTransgender.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnTransgenderFemale.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnAgender.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnOther.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            
            self.genderId = "\(self.arrGender[sender.tag].id!)"
        }
        else if sender.tag == 2{
            
            self.btnMale.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnFemale.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnTransgender.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            self.btnTransgenderFemale.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnAgender.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnOther.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            
            self.genderId = "\(self.arrGender[sender.tag].id!)"
        }
        else if sender.tag == 3{
            
            self.btnMale.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnFemale.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnTransgender.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnTransgenderFemale.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            self.btnAgender.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnOther.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            
            self.genderId = "\(self.arrGender[sender.tag].id!)"
        }
        else if sender.tag == 4{
            
            self.btnMale.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnFemale.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnTransgender.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnTransgenderFemale.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnAgender.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            self.btnOther.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            
            self.genderId = "\(self.arrGender[sender.tag].id!)"
        }
        else{
            
            self.btnMale.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnFemale.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnTransgender.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnTransgenderFemale.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnAgender.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnOther.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            
            self.genderId = "\(self.arrGender[sender.tag].id!)"
        }
        
    }
    
    @IBAction func btnRaceAction(_ sender: UIButton) {
        
        if sender.tag == 0{
            
            self.btnAmericanIndian.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            self.btnAsian.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnBlackAfrican.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnHispanic.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnNativeHawaiian.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnWhite.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnRaceOther.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            
            self.raceId = "\(self.arrRace[sender.tag].id!)"
        }
        else if sender.tag == 1{
            
            self.btnAmericanIndian.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnAsian.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            self.btnBlackAfrican.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnHispanic.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnNativeHawaiian.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnWhite.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnRaceOther.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            
            self.raceId = "\(self.arrRace[sender.tag].id!)"
        }
        else if sender.tag == 2{
            
            self.btnAmericanIndian.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnAsian.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnBlackAfrican.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            self.btnHispanic.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnNativeHawaiian.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnWhite.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnRaceOther.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            
            self.raceId = "\(self.arrRace[sender.tag].id!)"
        }
        else if sender.tag == 3{
            
            self.btnAmericanIndian.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnAsian.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnBlackAfrican.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnHispanic.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            self.btnNativeHawaiian.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnWhite.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnRaceOther.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            
            self.raceId = "\(self.arrRace[sender.tag].id!)"
        }
        else if sender.tag == 4{
            
            self.btnAmericanIndian.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnAsian.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnBlackAfrican.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnHispanic.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnNativeHawaiian.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            self.btnWhite.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnRaceOther.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            
            self.raceId = "\(self.arrRace[sender.tag].id!)"
        }
        else if sender.tag == 5{
            
            self.btnAmericanIndian.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnAsian.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnBlackAfrican.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnHispanic.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnNativeHawaiian.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnWhite.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            self.btnRaceOther.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            
            self.raceId = "\(self.arrRace[sender.tag].id!)"
        }
        else{
            
            self.btnAmericanIndian.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnAsian.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnBlackAfrican.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnHispanic.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnNativeHawaiian.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnWhite.setImage(#imageLiteral(resourceName: "circle_unCheck"), for: .normal)
            self.btnRaceOther.setImage(#imageLiteral(resourceName: "select_check"), for: .normal)
            
            self.raceId = "\(self.arrRace[sender.tag].id!)"
        }

    }
    
    
    @IBAction func btnBeHeardAction(_ sender: UIButton) {
        
        if self.incomeId == ""{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: "Select your Income", delegate: self)
            return
        }
        if self.departmentId == ""{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: "Choose your job level", delegate: self)
            return
        }
        if self.generationId == ""{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: "Choose your generation", delegate: self)
            return
        }
        if self.genderId == ""{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: "Choose your gender", delegate: self)
            return
        }
        if self.raceId == ""{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: "Choose your race", delegate: self)
            return
        }
        if AppUtility.shared.isEmpty(self.txtCompany.text!){
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: "Company name is required", delegate: self)
            return
        }
        if self.industryId == ""{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: "Select your industry", delegate: self)
            return
        }
        if self.countryId == ""{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: "Select your country", delegate: self)
            return
        }
        if self.stateId == ""{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: "Select your state", delegate: self)
            return
        }
        
        callBeHeardSendDataAPI()
        
    }
 
    //MARK: API Methods
    func callBeHeardAPI(){
        
        if AppUtility.shared.connected() == false{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("no_network_alert_title", comment: ""), messageText: NSLocalizedString("no_network_alert_description", comment: ""), delegate: self)
            return
        }
                
        APIHandler.sharedInstance.beHeard{ (isSuccess, response) in

            if isSuccess == true{

                if response!["code"] as! Int == 200{
                    
                    if let data = response!["data"] as? NSDictionary{
                        
                        let income = data["incomes"] as! [[String : Any]]
                        self.arrIncomes = (income).map({incomes.map(JSONObject: $0, context: nil)})
                        
                        
                        let department = data["departments"] as! [[String: Any]]
                        self.arrDepartments = (department).map({departments.map(JSONObject: $0, context: nil)})
                        
                        let generation = data["generations"] as! [[String: Any]]
                        self.arrGeneration = (generation).map({generations.map(JSONObject: $0, context: nil)})
                        
                        let gender = data["genders"] as! [[String: Any]]
                        self.arrGender = (gender).map({genders.map(JSONObject: $0, context: nil)})
                        
                        let race = data["races"] as! [[String: Any]]
                        self.arrRace = (race).map({races.map(JSONObject: $0, context: nil)})
                        
                        
                        let industrie = data["industries"] as! [[String : Any]]
                        self.arrIndustries = (industrie).map({industries.map(JSONObject: $0, context: nil)})
                        
                        let countrie = data["countries"] as! [[String : Any]]
                        self.arrCountries = (countrie).map({countries.map(JSONObject: $0, context: nil)})
                        
                        let state = data["states"] as! [[String : Any]]
                        self.arrStates = (state).map({states.map(JSONObject: $0, context: nil)})
                        
                    }
                }
                else{
                    
                    let message = response!["message"] as! String
                    AppUtility.shared.displayAlert(title: NSLocalizedString("alert_error_title", comment: ""), messageText: message, delegate: self)
                }
            }
            else{

                AppUtility.shared.displayAlert(title: NSLocalizedString("alert_error_title", comment: ""), messageText: NSLocalizedString("error_400", comment: ""), delegate: self)
            }
        }
    }
    
    func callBeHeardSendDataAPI(){
        
        self.myUser = User.readUserFromArchive()
        let api_token = self.myUser![0].api_token!
        let param = ["income_id": self.incomeId, "department_id": self.departmentId, "generation_id": self.generationId, "gender_id": self.genderId, "other_gender": self.genderId, "race_id": self.raceId, "other_race": self.raceId, "company": self.txtCompany.text!, "industry_id": self.industryId, "country_id": self.countryId, "state_id": self.stateId, "api_token": api_token]
        
        
        if AppUtility.shared.connected() == false{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("no_network_alert_title", comment: ""), messageText: NSLocalizedString("no_network_alert_description", comment: ""), delegate: self)
            return
        }
        
        APIHandler.sharedInstance.beHeardSendData(param: param) { (isSuccess, response) in
            
            if isSuccess == true{
                
                if response!["code"] as! Int == 200{
                    
                    self.myUser = User.readUserFromArchive()
                    self.myUser![0].usr_status = "1"
                    
                    if User.saveUserToArchive(user: self.myUser!){
                        
                        let data = UserDefaults.standard.value(forKey: "userAgreeTerms")
                        if data != nil{
                            
                            let story = UIStoryboard(name: "Main", bundle: nil)
                            let tabbarVC = story.instantiateViewController(withIdentifier: "tabbarVC") as! TabBarViewController
                            tabbarVC.modalPresentationStyle = .fullScreen
                            self.present(tabbarVC, animated: true, completion: nil)
                        }
                        else{
                            
                            let termsVC = self.storyboard?.instantiateViewController(withIdentifier: "termsVC") as! TermsViewController
                            self.navigationController?.pushViewController(termsVC, animated: true)
                        }
                        
                    }
                }
                else{
                    
                    let message = response!["message"] as! String
                    AppUtility.shared.displayAlert(title: NSLocalizedString("alert_error_title", comment: ""), messageText: message, delegate: self)
                }
            }
            else{
                
                AppUtility.shared.displayAlert(title: NSLocalizedString("alert_error_title", comment: ""), messageText: NSLocalizedString("error_400", comment: ""), delegate: self)
            }
        }
    }
    
    
    //MARK:- DELEGATE METHODS
    
    //MARK: TableView
    
    //MARK: CollectionView
    
    //MARK: Segment Control
    
    //MARK: Alert View
    
    //MARK: TextField

}
