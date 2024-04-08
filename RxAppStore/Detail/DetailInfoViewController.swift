//
//  DetailInfoViewController.swift
//  RxAppStore
//
//  Created by ungQ on 4/8/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class DetailInfoViewController: UIViewController {


	let viewModel = DetailInfoViewModel()

	var result: AppResult?

	let scrollView = UIScrollView()
	let contentView = UIView()

	let appIconImagieView = UIImageView()
	let appNameLabel = UILabel()
	let corpNameLabel = UILabel()
	let downloadButton =  UIButton()
	let overviewLabel = UILabel()

	let tempImageView1 = UIImageView()
	let tempImageView2 = UIImageView()

	let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white

		configureLayout()
		bind()
    }

	func bind() {

		guard let result = result else { return }
		let data = BehaviorSubject(value: result)
		let input = DetailInfoViewModel.Input(data: data)

		let output = viewModel.transform(input: input)
		output.data.bind(with: self) { owner, data in
			print(data.artworkUrl512)
			owner.appIconImagieView.kf.setImage(with: data.artworkUrl512)
			owner.appNameLabel.text = data.trackCensoredName
			owner.corpNameLabel.text = data.sellerName
			owner.tempImageView1.kf.setImage(with: data.screenshotUrls[0])
			owner.tempImageView2.kf.setImage(with: data.screenshotUrls[1])
			owner.overviewLabel.text = data.description

		}
		.disposed(by: bag)

	}

	func configureLayout() {

		view.addSubview(scrollView)
		scrollView.addSubview(contentView)
		contentView.addSubview(appIconImagieView)
		contentView.addSubview(appNameLabel)
		contentView.addSubview(corpNameLabel)
		contentView.addSubview(downloadButton)
		contentView.addSubview(overviewLabel)

		contentView.addSubview(tempImageView1)
		contentView.addSubview(tempImageView2)

		scrollView.snp.makeConstraints { make in
			make.edges.equalTo(view.safeAreaLayoutGuide)
		}

		contentView.snp.makeConstraints { make in
			make.verticalEdges.equalTo(scrollView)
			make.width.equalTo(scrollView.snp.width)
		}
		contentView.backgroundColor = .systemBlue

		scrollView.backgroundColor = .systemRed

		appIconImagieView.backgroundColor = .black


		appIconImagieView.snp.makeConstraints { make in
	  make.top.leading.equalToSuperview().inset(8)
	  make.width.height.equalTo(100) // Assuming you want a 100x100 icon
  }

  appNameLabel.snp.makeConstraints { make in
	  make.top.equalToSuperview().offset(8)
	  make.leading.equalTo(appIconImagieView.snp.trailing).offset(8)
	  make.trailing.equalToSuperview().inset(8)
	  make.height.equalTo(36)
  }

  corpNameLabel.snp.makeConstraints { make in
	  make.top.equalTo(appNameLabel.snp.bottom)
	  make.leading.equalTo(appIconImagieView.snp.trailing).offset(8)
	  make.trailing.equalToSuperview().inset(8)
	  make.height.equalTo(20)
  }

  downloadButton.snp.makeConstraints { make in
	  make.top.equalTo(corpNameLabel.snp.bottom)
	  make.leading.equalTo(appIconImagieView.snp.trailing).offset(8)
	  make.width.equalTo(80)
	  make.height.equalTo(36)
  }

		tempImageView1.snp.makeConstraints { make in
			make.top.equalTo(appIconImagieView.snp.bottom).offset(8)
			make.leading.equalToSuperview().offset(8)
			make.width.equalTo(view.bounds.width/2)
			make.height.equalTo(tempImageView1.snp.width).multipliedBy(2)
		}

		tempImageView2.snp.makeConstraints { make in
			make.top.equalTo(appIconImagieView.snp.bottom).offset(8)
			make.trailing.equalToSuperview().offset(-8)
			make.width.equalTo(view.bounds.width/2)
			make.height.equalTo(tempImageView1.snp.width).multipliedBy(2)
		}

  overviewLabel.snp.makeConstraints { make in
	  make.top.equalTo(tempImageView1.snp.bottom).offset(8)
	  make.horizontalEdges.equalToSuperview().inset(8)
	  make.bottom.equalTo(contentView.snp.bottom).inset(8)

  }

		overviewLabel.backgroundColor = .systemBrown
		overviewLabel.numberOfLines = 0


		


	}

}
