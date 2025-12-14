import UIKit

struct FilterItem {
    let id: Int
    let name: String
}

final class FilterViewController: UIViewController {
    private let filterTitle: String
    private let items: [FilterItem]
    private var selectedIds: Set<Int>
    private let onApply: (Set<Int>) -> Void
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "FilterCell")
        tv.backgroundColor = AppColors.background
        return tv
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply Filters", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppColors.primary
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(applyTapped), for: .touchUpInside)
        return button
    }()
    
    init(
        title: String,
        items: [FilterItem],
        selectedIds: Set<Int>,
        onApply: @escaping (Set<Int>) -> Void
    ) {
        self.filterTitle = title
        self.items = items
        self.selectedIds = selectedIds
        self.onApply = onApply
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = filterTitle
        view.backgroundColor = AppColors.background
        
        view.addSubview(tableView)
        view.addSubview(applyButton)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -16),
            
            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            applyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func applyTapped() {
        onApply(selectedIds)
        navigationController?.popViewController(animated: true)
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.name
        cell.textLabel?.textColor = AppColors.textPrimary
        cell.backgroundColor = AppColors.background
        cell.tintColor = AppColors.primary
        cell.accessoryType = selectedIds.contains(item.id) ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = items[indexPath.row]
        if selectedIds.contains(item.id) {
            selectedIds.remove(item.id)
        } else {
            selectedIds.insert(item.id)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
