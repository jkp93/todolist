import UIKit

// Custom UITableViewCell subclass for task cell
class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneSwitch: UISwitch! // UISwitch 했을을 표시할 수 있는 스위치

    var switchValueChanged: ((Bool) -> Void)? // 스위치 밸류 변경을 위한 클로저

    // 스위치 밸류 변경의 액션
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        switchValueChanged?(sender.isOn)
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var data = ["title1", "title2", "title3", "title4"]

    @IBOutlet weak var tableView: UITableView!
    
    //View 로딩된 후 >>><<<
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.frame = view.bounds
        
        //dataSource와 delegate는 self에 지정
        tableView.dataSource = self
        tableView.delegate = self
        
        // Register custom cell from nib file
                tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        
        //subView??
        view.addSubview(tableView)
        
        // 네이게이션바에 추가 버튼을 추가
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addItem() {
           // alert controller 생성
           let alertController = UIAlertController(title: "추가하기", message: "할 일을 추가해 주세요", preferredStyle: .alert)
           
           // Add text field for title input
           alertController.addTextField { textField in
               textField.placeholder = "Title"
           }
           
           // 추가 기능에 액션 추가 (추가하기 버튼)
           let addAction = UIAlertAction(title: "Add", style: .default) { _ in
               if let title = alertController.textFields?.first?.text, !title.isEmpty {
                   self.data.append(title)
                   self.tableView.reloadData()
               }
           }
           alertController.addAction(addAction)
           
           // 취소 기능 액션 추가 (취소하기 버튼)
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
           alertController.addAction(cancelAction)
           
           // alert control 보이게 하기
           present(alertController, animated: true, completion: nil)
       }
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1 // Assuming you only have one section
     }
    
    //Table의 행(row) 수를 보고하는 함수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    //각 행에 셀을 만들어주는 함수, 어떤 컨텐츠가 들어갈지 정해준다
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        cell.textLabel?.text = data[indexPath.row]
//        return cell
//    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell

        let task = data[indexPath.row]
        cell.titleLabel.text = task
        cell.doneSwitch.isOn = false // Set switch state
        
        // Closure to handle switch value change
        cell.switchValueChanged = { isOn in            
            // Use self here if necessary
            // For example:
            print("Switch value changed to \(isOn)")
        }

        return cell
    }
    
//    //셀이 눌렸을 때 문구 프린트와 눌렀다 땐 느낌을 주는 함수
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Selected: \(data[indexPath.row])")
//        
//        //눌렀을 때 음영처리 해주는 애니메이션
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//}

    // UITableViewDelegate method for handling cell selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected: \(data[indexPath.row])")
        
        //눌렀을 때 음영처리 해주는 애니메이션
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
