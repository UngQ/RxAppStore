//
//  SearchHistoryViewController.swift
//  RxMusic
//
//  Created by ungQ on 4/7/24.
//

import UIKit

class SearchHistoryViewController: UIViewController {

	let historyTableView = UITableView()
	
	let currentLabel = {
		let view = UILabel()
		view.text = "최근 검색 기록"
		view.backgroundColor = .green
		return view
	}()

	let allDeleteButton = {
		let view = UIButton()
		view.setTitle("모두 지우기", for: .normal)

		view.backgroundColor = .darkGray
		return view
	}()

    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = .systemBlue

		view.addSubview(historyTableView)
		view.addSubview(currentLabel)
		view.addSubview(allDeleteButton)


		currentLabel.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.leading.equalToSuperview().offset(4)
		}
		allDeleteButton.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.trailing.equalToSuperview().offset(-4)
			make.width.greaterThanOrEqualTo(0)
			make.height.equalTo(currentLabel.snp.height)
		}
		historyTableView.snp.makeConstraints { make in
			make.top.equalTo(allDeleteButton.snp.bottom)
			make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
		}

		historyTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		historyTableView.backgroundColor = .systemGray

    }
    

  


}
