import UIKit

final class ModernButton: UIButton {
    
    enum Style {
        case primary
        case secondary
        case text
        
        var backgroundColor: UIColor {
            switch self {
            case .primary:
                return AppColors.primary
            case .secondary:
                return AppColors.surface
            case .text:
                return .clear
            }
        }
        
        var titleColor: UIColor {
            switch self {
            case .primary:
                return .white
            case .secondary:
                return AppColors.primary
            case .text:
                return AppColors.primary
            }
        }
    }
    
    private let style: Style
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .white
        return indicator
    }()
    
    private var originalTitle: String?
    
    var isLoading: Bool = false {
        didSet {
            updateLoadingState()
        }
    }
    
    init(title: String, style: Style = .primary) {
        self.style = style
        self.originalTitle = title
        super.init(frame: .zero)
        setupUI(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(title: String) {
        translatesAutoresizingMaskIntoConstraints = false
        
        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        
        backgroundColor = style.backgroundColor
        setTitleColor(style.titleColor, for: .normal)
        setTitleColor(style.titleColor.withAlphaComponent(0.7), for: .highlighted)
        setTitleColor(AppColors.textSecondary, for: .disabled)
        
        layer.cornerRadius = 14
        
        if style == .primary {
            layer.shadowColor = AppColors.primary.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 4)
            layer.shadowRadius = 12
            layer.shadowOpacity = 0.3
        }
        
        if style == .secondary {
            layer.borderWidth = 1.5
            layer.borderColor = AppColors.primary.cgColor
        }
        
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc private func touchDown() {
        guard !isLoading else { return }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut, .allowUserInteraction]) {
            self.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            self.alpha = 0.8
        }
    }
    
    @objc private func touchUp() {
        guard !isLoading else { return }
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .allowUserInteraction) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }
    
    private func updateLoadingState() {
        isEnabled = !isLoading
        
        UIView.animate(withDuration: 0.2) {
            if self.isLoading {
                self.titleLabel?.alpha = 0
                self.activityIndicator.startAnimating()
            } else {
                self.titleLabel?.alpha = 1
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.alpha = self.isEnabled ? 1.0 : 0.6
                if self.style == .primary {
                    self.layer.shadowOpacity = self.isEnabled ? 0.3 : 0
                }
            }
        }
    }
}

