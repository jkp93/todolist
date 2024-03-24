import UIKit

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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
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
    
    //Table의 행(row) 수를 보고하는 함수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    //각 행에 셀을 만들어주는 함수, 어떤 컨텐츠가 들어갈지 정해준다
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    //셀이 눌렸을 때 문구 프린트와 눌렀다 땐 느낌을 주는 함수
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected: \(data[indexPath.row])")
        
        //눌렀을 때 음영처리 해주는 애니메이션
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
