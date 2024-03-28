import UIKit

struct ToDo : Codable {
    let title: String
    var isDone: Bool = false
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var data: [ToDo] = [ToDo(title: "title1"), ToDo(title: "title2"), ToDo(title: "title3")]
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //View 로딩된 후 >>><<<
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "To Do List"
        if let savedData = UserDefaults.standard.data(forKey: "todoData") {
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode([ToDo].self, from: savedData) {
                self.data = decodedData
            }
        }
        
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
    
    @objc func tapSwitchButton(sender: UISwitch) {
        let rowIndex = sender.tag
        data[rowIndex].isDone = sender.isOn
        tableView.reloadData()
    }
    
    //추가 기능
    @objc func addItem() {
        // alert controller 생성
        let alertController = UIAlertController(title: "추가하기", message: "할 일을 추가해 주세요", preferredStyle: .alert)
        
        // 텍스트를 넣기 위한 텍스트 필드 생성
        alertController.addTextField { textField in
            textField.placeholder = "새로 할 일 추가"
        }
        
        // 추가 기능에 액션 추가 (추가하기 버튼)
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self else { return }
            if let title = alertController.textFields?.first?.text, !title.isEmpty {
                
                
                //새로운 투두리스트 추가
                let newToDo = ToDo(title: title)
                self.data.append(newToDo)
                self.tableView.reloadData()
                
                //UserDefault에 새로운 data array 저장
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(self.data) {
                    UserDefaults.standard.set(encoded, forKey: "todoData")
                }
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
            return 1 // 1개의 섹션만 있다고 가정할 시
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
            
            let toDo = data[indexPath.row]
            let attributedString = NSMutableAttributedString(string: toDo.title)
            let range = NSRange(location: 0, length: attributedString.length)
            
            // 스위치가 on일 시 strikethroughStyle 줌
            if toDo.isDone {
                attributedString.addAttribute(.strikethroughStyle, value: 2, range: range)
            } else {
                attributedString.removeAttribute(.strikethroughStyle, range: range)
            }
            
            // 속성을 titleLabel에 부여
            cell.titleLabel.attributedText = attributedString
            
            cell.doneSwitch.isOn = toDo.isDone
                cell.doneSwitch.tag = indexPath.row
                cell.doneSwitch.addTarget(self, action: #selector(tapSwitchButton(sender:)), for: .valueChanged)
            
            let isDone = data[indexPath.row].isDone
            if isDone { //스위치 켜는 코드, 밑줄치는 코드
                cell.doneSwitch.isOn = true
                
            } else {  //반대 동작 코드
                cell.doneSwitch.isOn = false
            }
            
            // 스위치 값 변경에 대한 클로저
            cell.switchValueChanged = { [weak self] isOn in
                
                // 스위치 상태에 따라 텍스트 스타일 변경
                let attributedString = NSMutableAttributedString(string: toDo.title)
                let range = NSRange(location: 0, length: attributedString.length)
                
                if isOn {
                    self?.data[indexPath.row].isDone = true
                    attributedString.addAttribute(.strikethroughStyle, value: 2, range: range)
                } else {
                    self?.data[indexPath.row].isDone = false
                    attributedString.removeAttribute(.strikethroughStyle, range: range)
                }
                
                // 업데이트된 attributed text를 titleLabel로
                cell.titleLabel.attributedText = attributedString
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
        
        // 셀 셀렉션을 다루기 위한 UITableViewDelegate 메서드
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("Selected: \(data[indexPath.row])")
            
            //눌렀을 때 음영처리 해주는 애니메이션
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // 삭제 액션 (드래그 후)
                data.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

