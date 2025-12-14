//
//  UIViewControllerExtensions.swift
//  ayaq
//
//  Created by Bakberdi Esentai on 14.12.2025.
//

import UIKit

extension UIViewController {
    
    func showAlert(
        title: String?,
        message: String?,
        actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default)]
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
    
    func showErrorAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    func showSuccessAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: "Success",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    func showConfirmationAlert(
        title: String,
        message: String,
        confirmTitle: String = "Confirm",
        cancelTitle: String = "Cancel",
        confirmHandler: @escaping () -> Void
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: confirmTitle, style: .default) { _ in
            confirmHandler()
        })
        present(alert, animated: true)
    }
    
    func showLoading() {
        let loadingView = UIView(frame: view.bounds)
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        loadingView.tag = 999
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = loadingView.center
        activityIndicator.startAnimating()
        
        loadingView.addSubview(activityIndicator)
        view.addSubview(loadingView)
    }
    
    func hideLoading() {
        view.subviews.forEach { subview in
            if subview.tag == 999 {
                subview.removeFromSuperview()
            }
        }
    }
    
    var safeAreaTop: CGFloat {
        return view.safeAreaInsets.top
    }
    
    var safeAreaBottom: CGFloat {
        return view.safeAreaInsets.bottom
    }
    
    var safeAreaLeft: CGFloat {
        return view.safeAreaInsets.left
    }
    
    var safeAreaRight: CGFloat {
        return view.safeAreaInsets.right
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showToast(message: String, isError: Bool = false) {
        let toastContainer = UIView()
        toastContainer.backgroundColor = isError ? UIColor.systemRed : UIColor.systemGreen
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 12
        toastContainer.clipsToBounds = true
        
        let toastLabel = UILabel()
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.font = .systemFont(ofSize: 14, weight: .medium)
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        
        toastContainer.addSubview(toastLabel)
        view.addSubview(toastContainer)
        
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toastLabel.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor, constant: 16),
            toastLabel.trailingAnchor.constraint(equalTo: toastContainer.trailingAnchor, constant: -16),
            toastLabel.topAnchor.constraint(equalTo: toastContainer.topAnchor, constant: 12),
            toastLabel.bottomAnchor.constraint(equalTo: toastContainer.bottomAnchor, constant: -12),
            
            toastContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            toastContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            toastContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 2.0, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: { _ in
                toastContainer.removeFromSuperview()
            })
        })
    }
    
    func showErrorToast(message: String) {
        showToast(message: message, isError: true)
    }
    
    func showSuccessToast(message: String) {
        showToast(message: message, isError: false)
    }
    
}

