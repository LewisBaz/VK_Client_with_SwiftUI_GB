//
//  LoginViewController.swift
//  VK App
//
//  Created by Lev Bazhkov on 21.04.2021.
//

import UIKit
import WebKit
import FirebaseAuth

final class LoginViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var logo: UILabel!
    @IBOutlet private weak var login: UILabel!
    @IBOutlet private weak var password: UILabel!
    @IBOutlet private weak var loginText: UITextField!
    @IBOutlet private weak var passwordText: UITextField!
    @IBOutlet private weak var animationView: UIView!
    
    private var counter = 0
    private var handle: AuthStateDidChangeListenerHandle!
    
    @IBAction func registerButton(_ sender: Any) {
        let alert = UIAlertController(title: "Регистрация", message: "Зарегистрируйтесь", preferredStyle: .alert)
        alert.addTextField { textEmail in
                textEmail.placeholder = "Введите ваш E-Mail"
        }
        alert.addTextField { textPassword in
                textPassword.isSecureTextEntry = true
                textPassword.placeholder = "Введите ваш пароль"
        }
        let cancelAction = UIAlertAction(title: "Отмена",
                                             style: .cancel)
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
                guard let emailField = alert.textFields?[0],
                    let passwordField = alert.textFields?[1],
                    let password = passwordField.text,
                    let email = emailField.text else { return }
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
                if let error = error {
                    self?.showAlert(title: "Ошибка", message: error.localizedDescription)
                } else {
                    Auth.auth().signIn(withEmail: email, password: password)
                }
            }
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func enterButton(_ sender: Any) {
        guard let email = loginText.text, loginText.hasText,
              let password = passwordText.text, passwordText.hasText
                else {
                    self.showAlert(title: "Ошибка", message: "Логин или пароль не введены")
                    return
                }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let error = error {
                    self?.showAlert(title: "Ошибка", message: error.localizedDescription)
                } else {
                    self?.StartLoadingAnimation()
                }
            }
        }
    
    func showFeedVC() {
        guard let vc = storyboard?.instantiateViewController(identifier: "webView") else { return }
        guard let window = self.view.window else { return }
        window.rootViewController = vc
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertItem = UIAlertAction(title: "OK", style: .default)

        alertController.addAction(alertItem)
        present(alertController, animated: true, completion: nil)
    }
    
    func StartLoadingAnimation() {
        
        let firstDot = UIView(frame: CGRect(x: 5, y: 10, width: 10, height: 10))
        let secondDot = UIView(frame: CGRect(x: 25, y: 10, width: 10, height: 10))
        let thirdDot = UIView(frame: CGRect(x: 45, y: 10, width: 10, height: 10))
        
        firstDot.layer.cornerRadius = firstDot.frame.width/2
        secondDot.layer.cornerRadius = secondDot.frame.width/2
        thirdDot.layer.cornerRadius = thirdDot.frame.width/2
        
        animationView.alpha = 1
        animationView.backgroundColor = .systemTeal
        
        firstDot.alpha = 0

        animationView.addSubview(firstDot)
        animationView.addSubview(secondDot)
        animationView.addSubview(thirdDot)
                                 
        UIView.animateKeyframes(
            withDuration: 1.35,
            delay: 0,
            options: [],
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.1,
                                   relativeDuration: 1/4) {
                    firstDot.alpha = 0.5
                    firstDot.backgroundColor = .black
                }
                UIView.addKeyframe(withRelativeStartTime: 1/4,
                                   relativeDuration: 1/4) {
                    firstDot.alpha = 0
                    secondDot.alpha = 0.5
                    secondDot.backgroundColor = .black
                }
                UIView.addKeyframe(withRelativeStartTime: 2/4,
                                   relativeDuration: 1/4) {
                    secondDot.alpha = 0
                    thirdDot.alpha = 0.5
                    thirdDot.backgroundColor = .black
                }
                UIView.addKeyframe(withRelativeStartTime: 3/4,
                                   relativeDuration: 1/4) {
                    thirdDot.alpha = 0
                }
        }) { _ in
            if self.counter < 1 {
                self.counter += 1
                self.StartLoadingAnimation()
            } else {
                self.showFeedVC()
            }
        }
    }
    
//    func cloudAnimation(){
//
//            let cloudView = UIView()
//
//            view.addSubview(cloudView)
//            cloudView.translatesAutoresizingMaskIntoConstraints = false
//
//            NSLayoutConstraint.activate([
//                cloudView.topAnchor.constraint(equalTo: animationView.topAnchor, constant: -120),
//                cloudView.bottomAnchor.constraint(equalTo: animationView.topAnchor, constant: -10),
//                cloudView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -60),
//                cloudView.widthAnchor.constraint(equalToConstant: 120),
//                cloudView.heightAnchor.constraint(equalToConstant: 70)
//            ])
//
//            let path = UIBezierPath()
//            path.move(to: CGPoint(x: 10, y: 60))
//            path.addQuadCurve(to: CGPoint(x: 20, y: 40), controlPoint: CGPoint(x: 5, y: 50))
//            path.addQuadCurve(to: CGPoint(x: 40, y: 20), controlPoint: CGPoint(x: 20, y: 20))
//            path.addQuadCurve(to: CGPoint(x: 70, y: 20), controlPoint: CGPoint(x: 55, y: 0))
//            path.addQuadCurve(to: CGPoint(x: 80, y: 30), controlPoint: CGPoint(x: 80, y: 20))
//            path.addQuadCurve(to: CGPoint(x: 110, y: 60), controlPoint: CGPoint(x: 110, y: 30))
//            path.close()
//
//
//            let layerAnimation = CAShapeLayer()
//            layerAnimation.path = path.cgPath
//            layerAnimation.strokeColor = UIColor.systemBlue.cgColor
//            layerAnimation.fillColor = UIColor.clear.cgColor
//            layerAnimation.lineWidth = 8
//            layerAnimation.lineCap = .round
//
//            cloudView.layer.addSublayer(layerAnimation)
//
//            let pathAnimationEnd = CABasicAnimation(keyPath: "strokeEnd")
//            pathAnimationEnd.fromValue = 0
//            pathAnimationEnd.toValue = 1
//            pathAnimationEnd.duration = 2
//            pathAnimationEnd.fillMode = .both
//            pathAnimationEnd.isRemovedOnCompletion = false
//            layerAnimation.add(pathAnimationEnd, forKey: nil)
//
//            let pathAnimationStart = CABasicAnimation(keyPath: "strokeStart")
//            pathAnimationStart.fromValue = 0
//            pathAnimationStart.toValue = 1
//            pathAnimationStart.duration = 2
//            pathAnimationStart.fillMode = .both
//            pathAnimationStart.isRemovedOnCompletion = false
//            pathAnimationStart.beginTime = 1
//
//            let animationGroup = CAAnimationGroup()
//            animationGroup.duration = 3
//            animationGroup.fillMode = CAMediaTimingFillMode.backwards
//            animationGroup.animations = [pathAnimationEnd, pathAnimationStart]
//            animationGroup.repeatCount = .infinity
//            layerAnimation.add(animationGroup, forKey: nil)
//
//        }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        self.handle = Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.showFeedVC()
                self.loginText.text = nil
                self.passwordText.text = nil
            }
        }
    }
       
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       }
       
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
       }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    @objc func hideKeyboard() {
        scrollView?.endEditing(true)
    }
    
    // Когда клавиатура появляется
    @objc func keyboardWasShown(notification: Notification) {
        
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }
        // Do any additional setup after loading the view.
}

