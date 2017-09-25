//
//  AuthService.swift
//  Ddddrible
//
//  Created by __End on 2017/9/25.
//  Copyright © 2017年 Dressrose. All rights reserved.
//

import SafariServices
import URLNavigator

import Alamofire
import KeychainAccess
import RxSwift


protocol AuthServiceType {
    
    var currentAccessToken: AccessToken? { get }
    
    /// Start OAuth authorization process.
    ///
    /// - returns: An Observable of `AccessToken` instance.
    func authorize() -> Single<Void>
    
    /// Call this method when redirected from OAuth process to request access token.
    ///
    /// - parameter code: `code` from redirected url.
    func callbakc(code: String)
    
    func logout()
}

final class AuthService: AuthServiceType {
    
    private(set) var currentAccessToken: AccessToken?
    
    fileprivate let clientID = "130182af71afe5247b857ef622bd344ca5f1c6144c8fa33c932628ac31c5ad78"
    fileprivate let clientSecret = "bbebedc51c2301049c2cb57953efefc30dc305523b8fdfadb9e9a25cb81efa1e"
    
    fileprivate var currentViewController: UIViewController?
    fileprivate let callbackSubject = PublishSubject<String>()
    
    fileprivate let keychain = Keychain(service: "com.ddddrible.ios")
    
    func authorize() -> PrimitiveSequence<SingleTrait, Void> {
        
        let parameters: [String: Any] = [
            "cilient_id": self.clientID,
            "scope": "public+write+comment+upload",
        ]
        
        let parameterString = parameters.map { "\($0)=\($1)" }.joined(separator: "&")
        let url = URL(string: "https://dribbble.com/oauth/authorize?\(parameterString)")!
        
        // ⚠️ Default animation of presenting SFSafariViewController is similar to 'push' animation
        // (from right to left). To use 'modal' animation (from bottom to top), we have to wrap
        // SFSafariViewController with UINavigationController and set navigation bar hidden.
        let safariViewController = SFSafariViewController(url: url)
        let navigationController = UINavigationController(rootViewController: safariViewController)
        navigationController.isNavigationBarHidden = true
        Navigator.present(navigationController)
        self.currentViewController = navigationController
        
        return self.callbackSubject.asSingle().flatMap(self.accessToken).do(onNext: { [weak self] accessToken in
            
            try self?.saveAccessToken(accessToken)
            self?.currentAccessToken = accessToken
            
        }).map { _ in Void() }
    }
    
    func callbakc(code: String) {
        self.callbackSubject.onNext(code)
        self.currentViewController?.dismiss(animated: true, completion: nil)
        self.currentViewController = nil
    }
    
    func logout() {
        self.currentAccessToken = nil
        self.removeAccessToken()
    }
    
    // MARK: private methods
    fileprivate func accessToken(code: String) -> Single<AccessToken> {
        let urlString = "https://dribbble.com/oauth/token"
        let parameters: Parameters = [
            "client_id": self.clientID,
            "client_secret": self.clientSecret,
            "code": code
        ]
        return Single.create { (observer) -> Disposable in
            let request = Alamofire.request(urlString, method: .post, parameters: parameters).responseString { response in
                switch response.result {
                case .success(let JSON):
                    do {
                        let accessToken = try AccessToken(JSONString: JSON)
                        observer(.success(accessToken))
                    } catch let error {
                        observer(.error(error))
                    }
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create { request.cancel() }
        }
    }
    
    fileprivate func saveAccessToken(_ accessToken: AccessToken) throws {
        try self.keychain.set(accessToken.accessToken, key: "access_token")
        try self.keychain.set(accessToken.tokenType, key: "token_type")
        try self.keychain.set(accessToken.scope, key: "scope")
    }
    
    fileprivate func loadAccessToken() -> AccessToken? {
        if let accessToken = self.keychain["access_token"],
           let tokenType = self.keychain["token_type"],
           let scope = self.keychain["scope"]
        {
            return AccessToken(accessToken: accessToken, tokenType: tokenType, scope: scope)
        }
        return nil
    }
    
    fileprivate func removeAccessToken() {
        try? self.keychain.remove("access_token")
        try? self.keychain.remove("token_type")
        try? self.keychain.remove("scope")
    }
}




