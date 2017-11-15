//
//  ViewController.swift
//  SecondTour
//
//  Created by Gena Beraylik on 11.11.2017.
//  Copyright © 2017 Beraylik. All rights reserved.
//

import UIKit
import CoreData

class VoyagerViewController: UIViewController {

    var field: Array<Array<Int>> = []
    var fieldSize: Int = 0
    var bestScore = 60
    var bestPathSteps = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let generateBtn = UIBarButtonItem(title: "Generate", style: .plain, target: self, action: #selector(setSize))
        
        self.navigationItem.title = "Find Path"
        self.navigationItem.rightBarButtonItem = generateBtn
            view.backgroundColor = .gray
        
        self.setSize()
        
        //generateField(size: 8)
        
        //findPathBetween(townA: 2, townB: 4, oldScore: 0, oldPath: "2")
        
        //setupViews()
    }
    
    func generateField(size: Int) { // Генерация матрицы расстояний
        field = Array.init(repeating: Array.init(repeating: 0, count: size+1), count: size+1)
        for i in 0...size {
            for j in 0...size {
                
                let distance = Int(arc4random()) % 45 + 5
                if i == j  {
                    field[i][j] = 0
                } else if i == 0 {
                    field[i][j] = j
                } else if j == 0 {
                    field[i][j] = i
                } else if i < j {
                    field[i][j] = distance
                    field[j][i] = distance
                }
            }
        }
        self.fieldSize = size
        for row in field {
            print(row)
        }
    }
    
    
    func findPathBetween(townA: Int, townB: Int, oldScore: Int, oldPath: String) { // Вычисление наискорейшего пути
        for town in 1...fieldSize {
            let pathScore = field[townA][town] + oldScore
            let pathSteps = "\(oldPath) -> \(town)"
            if pathScore > bestScore {
                continue
            }
            if town == townB {
                if pathScore < bestScore {
                    bestScore = pathScore
                    bestPathSteps = pathSteps
                }
                continue
            } else if town != townA {
                findPathBetween(townA: town, townB: townB, oldScore: pathScore, oldPath: pathSteps)
            }
        }
    }
    
    func saveTheRecord() { // Преобразование архива в строку для сохранения в БД
        var fieldSting = ""
        for i in 0..<field.count {
            fieldSting += ">"
            for j in 0..<field[i].count {
                fieldSting.append("\(field[i][j]),")
            }
            fieldSting.removeLast(1)
            
        }
        
        print(fieldSting)
        
        
        let context = AppDelegate().persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Voyagers", in: context)!
        let voyager = NSManagedObject(entity: entity, insertInto: context)
        
        voyager.setValue(bestScore, forKey: "score")
        voyager.setValue(bestPathSteps, forKey: "path")
        voyager.setValue(fieldSting, forKey: "field")
        voyager.setValue(NSDate(), forKey: "date")
        
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @objc func calculatePath() {
        bestScore = 99
        bestPathSteps = ""
        
        var pointA: Int
        var pointB: Int
        
        pointA = Int(townAField.text! ) ?? 0
        pointB = Int(townBField.text! ) ?? 0
        
        if (pointA != pointB) && (pointA <= fieldSize)
        && (pointB <= fieldSize) && (pointA > 0) && (pointB > 0) {
            
            findPathBetween(townA: pointA, townB: pointB, oldScore: 0, oldPath: String(pointA))
            
            self.descriptionField.font = UIFont.boldSystemFont(ofSize: 18)
            self.descriptionField.text = "Best score is:  \(bestScore) \n Best path is: \n \(bestPathSteps)"
            
            print("Best path is:  \(bestPathSteps)")
            print("Best score is:  \(bestScore)")
            
            saveTheRecord()
            
            self.view.reloadInputViews()
        } else {
            let alert = UIAlertController(title: "Alert", message: "Wrong input", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
 
    }
    
    @objc func setSize() {
        
        let alertController = UIAlertController(title: "Generate field", message: "Enter prefered size for field from 1 to 10", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { (textField) in
            textField.keyboardType = .numberPad
            textField.placeholder = "1...10"
        })
        let enterAction = UIAlertAction(title: "Enter", style: .default, handler: {(_) in
            let newSize = Int(alertController.textFields![0].text ?? "0") ?? 0
            if newSize > 0 && newSize <= 10 {
                self.generateField(size: newSize)
                self.setupViews()
            } else {
                let alert = UIAlertController(title: "Alert", message: "Wrong input", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        })
        let cancelAction = UIAlertAction (title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(enterAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() { // Построение интерфейса
        for view in view.subviews {
            view.removeFromSuperview()
        }
        
        view.addSubview(descriptionField)
        descriptionField.text = "Here is your voyager. \n Generate field size and \n pick destination points"
        descriptionField.sizeToFit()
        let descriptionPadding: Int = Int((view.frame.width - (descriptionField.frame.width+10)) / 2)
        let textHeight = descriptionField.frame.height + 10
        
        let fieldView = drawFieldView()
        let matrixPadding: Int = (Int(view.frame.width) - 33*(fieldSize+1)) / 2
        view.addSubview(fieldView)
        
        
        let inputPadding: Int = (Int(view.frame.width) - 240) / 2
        let inputContainerView = UIView()
        inputContainerView.addSubview(townAField)
        inputContainerView.addSubview(townBField)
        inputContainerView.addConstraintsWith(format: "H:|[v0(100)]-50-[v1(100)]", views: [townAField, townBField])
        inputContainerView.addConstraintsWith(format: "V:|[v0(40)]|", views: [townAField])
        inputContainerView.addConstraintsWith(format: "V:|[v0(40)]|", views: [townBField])
        view.addSubview(inputContainerView)
        
        view.addSubview(calculateBtn)
        let btnPadding: Int = (Int(view.frame.width) - 150) / 2
        
        view.addConstraintsWith(format: "H:|-\(descriptionPadding)-[v0]-\(descriptionPadding)-|", views: [descriptionField])
        view.addConstraintsWith(format: "H:|-\(matrixPadding)-[v0]-\(matrixPadding)-|", views: [fieldView])
        view.addConstraintsWith(format: "H:|-\(inputPadding)-[v0]-\(inputPadding)-|", views: [inputContainerView])
        view.addConstraintsWith(format: "H:|-\(btnPadding)-[v0]-\(btnPadding)-|", views: [calculateBtn])
        view.addConstraintsWith(format: "V:|-75-[v0(\(textHeight))]-15-[v2(40)]-15-[v1(\(32*(fieldSize+1)))]-20-[v3(40)]", views: [descriptionField, fieldView, inputContainerView, calculateBtn])
        
        
    }
    
    
    func drawFieldView() -> UIView { // Создание View с Матрицей расстояний
        let fieldView = UIView()
        fieldView.backgroundColor = .black

        var verticalVF = "V:|"
        var rowsArray: [UIView] = []
        
        for i in 0..<field.count {
            let row = UIView()
            var itemsArray: [UIView] = []
            for j in 0..<field[i].count {
                let itemView = UILabel()
                itemView.text = String(field[i][j])
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
            fieldView.addSubview(row)
            
            rowsArray.append(row)
        }
        for (index, value) in rowsArray.enumerated() {
            
            fieldView.addConstraintsWith(format: "H:|-1-[v0]-1-|", views: [value])
            verticalVF += "[v\(index)(\(32))]"
        }
        print(verticalVF)
        fieldView.addConstraintsWith(format: verticalVF, views: rowsArray)
        
        return fieldView
    }

    let descriptionField: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.font = UIFont.systemFont(ofSize: 18)
        view.backgroundColor = .lightGray
        return view
    }()

    let townAField: UITextField = {
        let view = UITextField()
        view.placeholder = "Town A"
        view.layer.cornerRadius = 12
        view.textAlignment = .center
        view.backgroundColor = .lightGray
        view.keyboardType = .numberPad
        view.font = UIFont.systemFont(ofSize: 20)
        return view
    }()
    
    let townBField: UITextField = {
        let view = UITextField()
        view.placeholder = "Town B"
        view.layer.cornerRadius = 12
        view.textAlignment = .center
        view.backgroundColor = .lightGray
        view.keyboardType = .numberPad
        view.font = UIFont.systemFont(ofSize: 20)
        return view
    }()
    
    let calculateBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Calculate", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 12
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(calculatePath), for: .touchUpInside)
        return button
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}

