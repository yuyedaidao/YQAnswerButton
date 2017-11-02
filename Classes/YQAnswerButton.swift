//
//  YQRadioButton.swift
//  YQRadioButton
//
//  Created by Wang on 2017/11/2.
//  Copyright © 2017年 Wang. All rights reserved.
//

import UIKit

enum CircleStyle {
    case border
    case full
}

class CircleView: UIView {
    let circle = CAShapeLayer()
    var style = CircleStyle.border {
        didSet {
            updatePath()
        }
    }
    var color: UIColor? = UIColor.darkText
    
    init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        circle.lineWidth = 1
        updatePath()
        layer.addSublayer(circle)
    }
        
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePath()
    }
    
    func updatePath() {
        let height = self.bounds.height
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        circle.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: height, height: height))
        switch style {
        case .border:
            circle.fillColor = UIColor.clear.cgColor
            circle.strokeColor = color?.cgColor ?? nil
            circle.path = UIBezierPath(roundedRect: circle.bounds, cornerRadius: circle.bounds.height / 2).cgPath
        case .full:
            circle.fillColor = color?.cgColor ?? nil
            circle.strokeColor = circle.fillColor
            circle.path = UIBezierPath(roundedRect: circle.bounds, cornerRadius: circle.bounds.height / 2).cgPath
        }
        CATransaction.commit()
    }
}

enum YQAnswerButtonState: Int {
    case normal
    case right
    case error
}


@IBDesignable
class YQAnswerButton: UIControl {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    @IBInspectable var flagWidth: CGFloat = 30 {
        didSet {
            if let constraint = flagWidthConstraint {
                constraint.constant = flagWidth
            }
        }
    }
    
    @IBInspectable var text: String? = " " {
        didSet {
            rightTextLabel.text = text
        }
    }

    @IBInspectable var font: UIFont = UIFont.systemFont(ofSize: 17) {
        didSet {
            rightTextLabel.font = font
        }
    }

    @IBInspectable var flagLabel: String? = "A" {
        didSet {
            if buttonState == .normal {
                leftTextLabel.text = flagLabel
            }
        }
    }
    
    @IBInspectable var flagLabelFont: UIFont = UIFont.systemFont(ofSize: 17) {
        didSet {
            if buttonState == .normal {
                sizeAssistView.font = flagLabelFont
                leftTextLabel.font = flagLabelFont
            }
        }
    }
    
    //MARK:此属性完全是为了解决buttonState不能引出IBInspectable才声明的
    @IBInspectable var ibState: Int = 0 {
        didSet {
            guard let state = YQAnswerButtonState(rawValue: ibState) else {
                return
            }
            buttonState = state
        }
    }
    
    var buttonState: YQAnswerButtonState = .normal  {
        didSet {
            updateState(buttonState)
        }
    }
    
    private var textColors: [YQAnswerButtonState : UIColor] = [
        .normal: UIColor.darkText,
        .right: #colorLiteral(red: 0.1195351556, green: 0.7145161033, blue: 0.4674707055, alpha: 1),
        .error: UIColor.orange
    ]
    
    private var flagViewColors: [YQAnswerButtonState : UIColor] = [
        .normal: UIColor.darkText,
        .right: #colorLiteral(red: 0.1195351556, green: 0.7145161033, blue: 0.4674707055, alpha: 1),
        .error: UIColor.orange
    ]
    
    private var flagLabelColors: [YQAnswerButtonState : UIColor] = [
        .normal: UIColor.darkText,
        .right: UIColor.white,
        .error: UIColor.white
    ]
    
    private var clickedFont: UIFont {
        guard let font = UIFont(name: "iconfont", size: font.pointSize) else {
            fatalError("请先打开Info.plist文件,增加一个新的Array类型的键,键名设置为UIAppFonts(Fonts provided by application),增加字体的文件名:yqiconfont.ttf")
        }
        return font
    }
    
    private var sizeAssistView = UILabel()
    
    private var leftBgView: CircleView!
    private var leftTextLabel: UILabel!
    private var rightTextLabel: UILabel!
    private var flagWidthConstraint: NSLayoutConstraint?
    
    init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func updateState(_ state: YQAnswerButtonState) {
        let color = textColors[buttonState]
        let bgViewColor = flagViewColors[buttonState]
        let flagLabelColor = flagLabelColors[buttonState]
        
        leftTextLabel.textColor = flagLabelColor
        leftBgView.color = bgViewColor
        rightTextLabel.textColor = color
        
        switch buttonState {
        case .normal:
            leftTextLabel.font = flagLabelFont
            leftTextLabel.text = text
            leftBgView.style = .border
        case .right:
            leftTextLabel.font = clickedFont
            leftTextLabel.text = "\u{e645}"
            leftBgView.style = .full
        case .error:
            leftTextLabel.font = clickedFont
            leftTextLabel.text = "\u{e646}"
            leftBgView.style = .full
        }
    }
    func commonInit() {
        let color = textColors[.normal]
    
        leftBgView = CircleView()
        addSubview(leftBgView)
        leftTextLabel = UILabel()
        leftTextLabel.textColor = color
        leftTextLabel.text = flagLabel
        leftTextLabel.textAlignment = .center
        leftBgView.addSubview(leftTextLabel)
        
        sizeAssistView.isHidden = true
        sizeAssistView.text = " "
        sizeAssistView.backgroundColor = UIColor.red
        leftBgView.addSubview(sizeAssistView)
        
        rightTextLabel = UILabel()
        rightTextLabel.textColor = color
        rightTextLabel.numberOfLines = 0
        rightTextLabel.text = text
        addSubview(rightTextLabel)
        
        sizeAssistView.translatesAutoresizingMaskIntoConstraints = false
        leftBgView.translatesAutoresizingMaskIntoConstraints = false
        leftTextLabel.translatesAutoresizingMaskIntoConstraints = false
        rightTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //right
        flagWidthConstraint = NSLayoutConstraint(item: rightTextLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: flagWidth)
        addConstraint(flagWidthConstraint!)
        addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: rightTextLabel, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: rightTextLabel, attribute: .trailing, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: rightTextLabel, attribute: .bottom, multiplier: 1, constant: 0))
        
        //leftBgView
        addConstraint(NSLayoutConstraint(item: leftBgView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: leftBgView, attribute: .trailing, relatedBy: .equal, toItem: rightTextLabel, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: leftBgView, attribute: .centerY, relatedBy: .equal, toItem: rightTextLabel, attribute: .centerY, multiplier: 1, constant: 0))
        
        //assistView
        leftBgView.addConstraint(NSLayoutConstraint(item: sizeAssistView, attribute: .leading, relatedBy: .equal, toItem: leftBgView, attribute: .leading, multiplier: 1, constant: 30))
        leftBgView.addConstraint(NSLayoutConstraint(item: sizeAssistView, attribute: .top, relatedBy: .equal, toItem: leftBgView, attribute: .top, multiplier: 1, constant: 0))
        leftBgView.addConstraint(NSLayoutConstraint(item: leftBgView, attribute: .bottom, relatedBy: .equal, toItem: sizeAssistView, attribute: .bottom, multiplier: 1, constant: 0))
        
        //flagLabel
        leftBgView.addConstraint(NSLayoutConstraint(item: leftTextLabel, attribute: .leading, relatedBy: .equal, toItem: leftBgView, attribute: .leading, multiplier: 1, constant: 0))
        leftBgView.addConstraint(NSLayoutConstraint(item: leftTextLabel, attribute: .centerY, relatedBy: .equal, toItem: sizeAssistView, attribute: .centerY, multiplier: 1, constant: 0))
        leftBgView.addConstraint(NSLayoutConstraint(item: leftTextLabel, attribute: .width, relatedBy: .equal, toItem: sizeAssistView, attribute: .height, multiplier: 1, constant: 0))
        leftBgView.addConstraint(NSLayoutConstraint(item: leftTextLabel, attribute: .height, relatedBy: .equal, toItem: sizeAssistView, attribute: .height, multiplier: 1, constant: 0))
        
        updateState(.normal)
        
    }
    
    func setTextColor(_ color: UIColor, `for` state: YQAnswerButtonState) {
        textColors[state] = color
        if state == buttonState {
            rightTextLabel.textColor = color
        }
    }
    
    func setFlagViewColor(_ color: UIColor, `for` state: YQAnswerButtonState) {
        flagViewColors[state] = color
        if state == buttonState {
            leftBgView.color = color
        }
    }
    
    func setFlagLabelColors(_ color: UIColor, `for` state: YQAnswerButtonState) {
        flagLabelColors[state] = color
        if state == buttonState {
            leftTextLabel.textColor = color
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let size = rightTextLabel.sizeThatFits(UIScreen.main.bounds.size)
        return CGSize(width: size.width + flagWidth, height: size.height)
    }
    
}
