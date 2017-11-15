//
//  DetailsViewController.swift
//  SecondTour
//
//  Created by Gena Beraylik on 14.11.2017.
//  Copyright © 2017 Beraylik. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var voyagerStr: VoyageStruct?
    var mainField: [[Int]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        mainField = parseField(fieldString: (voyagerStr?.field)!)
        print(voyagerStr ?? "NONE")

        setupViews()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupViews() {
        for view in view.subviews {
            view.removeFromSuperview()
        }
        
        let dateString = DateFormatter.localizedString(from: (voyagerStr?.date)!, dateStyle: .short, timeStyle: .short)
        dateField.text = "Date: \(String(describing: dateString))"
        scoreField.text = "Best score: \(String(describing: (voyagerStr?.score)!))"
        pathField.text = "Best Path: \(String(describing: (voyagerStr?.path)!))"
        
        view.addSubview(scoreField)
        view.addSubview(pathField)
        view.addSubview(dateField)
        
        mainField = parseField(fieldString: (voyagerStr?.field)!)
        
        let fieldView = drawFieldView()
        fieldView.backgroundColor = .black
        let matrixPadding: Int = (Int(view.frame.width) - 33*(mainField.count)) / 2
        view.addSubview(fieldView)
        
        view.addConstraintsWith(format: "H:|-10-[v0]", views: [dateField])
        view.addConstraintsWith(format: "H:|-10-[v0]", views: [pathField])
        view.addConstraintsWith(format: "H:|-10-[v0]", views: [scoreField])
        view.addConstraintsWith(format: "H:|-\(matrixPadding)-[v0]-\(matrixPadding)-|", views: [fieldView])
        
        view.addConstraintsWith(format: "V:|-90-[v0]-15-[v1]-15-[v2]-20-[v3]", views: [dateField, pathField, scoreField, fieldView])
        
        
        
        
    }
    
    func parseField(fieldString: String) -> [[Int]] { // Преобразование строки Матрицы в Матрицу
        var result: [[Int]] = []
        
        let rowStrings = fieldString.split(separator: ">")
        for row in rowStrings {
            let numbers = row.split(separator: ",")
            var rowArr = [Int]()
            print(row)
            for number in numbers  {
                let intValue = Int(number) ?? 0
                rowArr.append(intValue)
                //print(number)
            }
            result.append(rowArr)
        }
        print(result)
        return result
    }
    
    func drawFieldView() -> UIView { // Создание View для отображения матрицы
        let fieldView = UIView()
        fieldView.backgroundColor = .black
        
        var verticalVF = "V:|"
        var rowsArray: [UIView] = []
        
        for i in 0..<mainField.count {
            let row = UIView()
            var itemsArray: [UIView] = []
            for j in 0..<mainField[i].count {
                let itemView = UILabel()
                itemView.text = String(mainField[i][j])
                if i == 0 || j == 0 {
                    itemView.backgroundColor = UIColor.red
                    itemView.font = UIFont.boldSystemFont(ofSize: 20)
                } else {
                    itemView.backgroundColor = UIColor.lightGray
                    itemView.font = UIFont.systemFont(ofSize: 20)
                }
                itemView.textAlignment = .center
                itemsArray.append(itemView)
            }
            var horisontalVF = "H:|"
            
            for (index, value) in itemsArray.enumerated() {
                
                let size = 30
                row.addSubview(value)
                horisontalVF += "[v\(index)(\(size))]-3-"
                row.addConstraintsWith(format: "V:|-1-[v0(\(size))]-1-|", views: [value])
            }
            horisontalVF.removeLast(3)
            row.addConstraintsWith(format: horisontalVF, views: itemsArray)
            row.backgroundColor = .black
            fieldView.addSubview(row)
            
            rowsArray.append(row)
        }
        for (index, value) in rowsArray.enumerated() {
            
            fieldView.addConstraintsWith(format: "H:|-1-[v0]-1-|", views: [value])
            verticalVF += "[v\(index)(\(32))]"
        }
        fieldView.backgroundColor = .black
        fieldView.addConstraintsWith(format: verticalVF, views: rowsArray)
        
        return fieldView
    }
    
    let scoreField: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 20)
        
        return view
    }()
    
    let pathField: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 20)
        
        return view
    }()

    let dateField: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 20)
        
        return view
    }()

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
