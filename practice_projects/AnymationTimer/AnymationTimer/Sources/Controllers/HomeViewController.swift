//
//  ViewController.swift
//  AnymationTimer
//
//  Created by Kyus'lee on 2023/02/23.
//

import UIKit

// MARK: - いつも、FileのDirectoryの区分を意識して、開発をする習慣をつけよう!
// Animation効果を使った簡単なTimerアプリ
// TimerViewとImageViewの間隔を置く方法として、UIViewの中にImageViewを置くといいかも

class HomeViewController: UIViewController {
    
    @IBOutlet weak var timerImageView: UIImageView! {
        didSet {
            timerImageView.clipsToBounds = true
            timerImageView.layer.cornerRadius = timerImageView.bounds.height / 2
        }
    }
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.alpha = 0
        }
    }
    @IBOutlet weak var timeProgressView: UIProgressView! {
        didSet {
            timeProgressView.alpha = 0
        }
    }
    @IBOutlet weak var playButton: UIButton! {
        didSet {
            setPlayButton()
        }
    }
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            setCancelButton()
        }
    }
    
    private let setTimeButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.buttonSize = .medium
        config.baseBackgroundColor = UIColor.systemBlue
        config.baseForegroundColor = UIColor.white
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        config.cornerStyle = .medium
        config.titleAlignment = .center
        config.attributedTitle = AttributedString("設定", attributes: AttributeContainer([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .medium)]))
        button.addTarget(nil, action: #selector(tapSetTimeButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        
        return button
    }()
    private let timerView: TimerView = {
        let view = TimerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    var duration = 60
    var timerStatus: TimerStatus = .end
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(setTimeButton)
        setSetTimeButtonConstraints()
        setImageView()
        setPlayButton()
        setCancelButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.timerImageView.addSubview(timerView)
        self.setTimerViewConstraints(on: self.timerImageView)
    }
    
    func setImageView() {
        guard let image = UIImage(named: "Timer") else { return }
        timerImageView.image = image
    }
    
    func setPlayButton() {
        guard let playImage = UIImage(systemName: "play.circle") else { return }
        let playImageConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .light)
        self.playButton.setImage(
            playImage.withTintColor(
                UIColor.blue.withAlphaComponent(0.7),
                renderingMode: .alwaysTemplate
            ),
            for: .normal
        )
        
        guard let pauseImage = UIImage(systemName: "pause.circle") else { return }
        let pauseImageConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .light)
        self.playButton.setImage(
            pauseImage.withTintColor(
                UIColor.blue.withAlphaComponent(0.7),
                renderingMode: .alwaysTemplate
            ),
            for: .selected
        )
    }
    
    func setCancelButton() {
        guard let image = UIImage(systemName: "stop.circle") else { return }
        self.cancelButton.setImage(
            image.withTintColor(
                UIColor.red.withAlphaComponent(0.7),
                renderingMode: .alwaysOriginal
            ),
            for: .normal
        )
        // playButtonが押されてない初期のときは、enabledをfalseにする
        self.cancelButton.isEnabled = false
    }
    
    // animate 再生に関するボタン
    @IBAction func tapPlayButton(_ sender: Any) {
        switch self.timerStatus {
        case .end:
            self.timerStatus = .start
            self.setTimerInfoViewVisible(isHidden: false)
            self.datePicker.isHidden = true
        case .start:
            self.timerStatus = .pause
        default:
            break
        }
    }
    
    // 一時停止ではなく、キャンセルのボタン
    @IBAction func tapCancelButton(_ sender: Any) {
        
    }
    
    // circle TimerViewのConstraintsを設定する
    private func setTimerViewConstraints(on subview: UIView) {
        NSLayoutConstraint.activate([
            timerView.leftAnchor.constraint(equalTo: subview.leftAnchor),
            timerView.rightAnchor.constraint(equalTo: subview.rightAnchor),
            timerView.topAnchor.constraint(equalTo: subview.topAnchor),
            timerView.bottomAnchor.constraint(equalTo: subview.bottomAnchor)
        ])
    }
    
    private func setSetTimeButtonConstraints() {
        NSLayoutConstraint.activate([
            setTimeButton.widthAnchor.constraint(equalToConstant: 120),
            setTimeButton.heightAnchor.constraint(equalToConstant: 45),
            setTimeButton.topAnchor.constraint(equalTo: self.datePicker.bottomAnchor, constant: 24),
            setTimeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    // すぐHiddenされるメソッド
    private func setTimerInfoViewVisible(isHidden: Bool) {
        self.timeLabel.isHidden = isHidden
        self.timeProgressView.isHidden = isHidden
    }
    
    // animate効果を与えたメソッド
    private func setTimerInfoViewVisibleWithAlpha(alpha: CGFloat) {
        self.timeLabel.alpha = alpha
        self.timeProgressView.alpha = alpha
    }
    
    // Timerの設定ボタンを押すと、DatePickerが消えて、labelとprogressViewが現れる
    @objc func tapSetTimeButton(_ sender: UIButton) {
        // countDownDuration Propertyは、DatePickerで選択した時間がなん秒であるかを返す
        self.duration = Int(self.datePicker.countDownDuration)
        debugPrint(self.duration)
        
        sender.isHidden = true
        UIView.animate(withDuration: 0.3) {
            // alphaでhiddenの効果を与えることで、animation効果が与えることができた
            self.datePicker.alpha = 0
            self.setTimerInfoViewVisibleWithAlpha(alpha: 1)
        }
    }
    


}

