//
//  FilterViewController.swift
//  TopNews
//
//  Created by Ilya Maier on 22.10.2020.
//  Copyright © 2020 mera. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate {
    func filterChanged(_ filter:FilterData);
}

class FilterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var filterData: FilterData?;
    var delegate: FilterViewControllerDelegate?;
    
    
    private let countries = FilterData.countries();
    private let categories = FilterData.categories();

    
    @IBOutlet weak var countryPickerView: UIPickerView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var keywordsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        if let filter = filterData {
            countryPickerView.selectRow(filter.country , inComponent: 0, animated: true);
            categoryPickerView.selectRow(filter.category+1, inComponent: 0, animated: true);
            keywordsTextField.text = filter.Keywords;
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        if var filter = filterData {
            filter.country = countryPickerView.selectedRow(inComponent: 0);
            filter.category = categoryPickerView.selectedRow(inComponent: 0) - 1;
            filter.Keywords = keywordsTextField.text!;
            if let del = delegate {
                del.filterChanged(filter);
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == countryPickerView {
            return countries.count;
        } else if pickerView == categoryPickerView {
            return categories.count + 1;
        }
        return 1;
    }
    
    //MARK: UIPickerViewDataSource
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == countryPickerView {
            return countries[row];
        } else if pickerView == categoryPickerView {
            if row == 0 {
                return "Not set";
            }
            return categories[row - 1];
        }
        return "Not supporeted";
    }
}
