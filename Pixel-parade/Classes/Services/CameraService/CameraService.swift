//
//  CameraService.swift
//  Pixel-parade
//
//  Created by Roman Solodyankin on 17/06/2019.
//  Copyright © 2019 Live Typing. All rights reserved.
//

import UIKit
import Photos

final class CameraService {
    
    typealias Action = () -> Void
    
    static func checkCameraAuthorization(_ completion: @escaping ((_ authorized: Bool) -> Void)) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { success in
                completion(success)
            })
        case .denied, .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
    static func checkPhotoLibraryAuthorization(_ completion: @escaping ((_ authorized: Bool) -> Void)) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ status in
                completion((status == .authorized))
            })
        case .denied, .restricted:
            completion(false)
            
        @unknown default:
            completion(false)
        }
    }
    
    static func settingsPopup(forType type: UIImagePickerController.SourceType) -> UIAlertController {
        let alertTitle = type == .camera ? R.string.localizable.errorCameraRestrictedTitle() : R.string.localizable.errorPhotoLibraryRestrictedTitle()
        let alertMessage = type == .camera ? R.string.localizable.errorCameraRestrictedMessage() : R.string.localizable.errorPhotoLibraryRestrictedMessage()
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let settingsButton = UIAlertAction(title: R.string.localizable.settings(), style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        let cancelButton = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: nil)
        alertController.addAction(settingsButton)
        alertController.addAction(cancelButton)
        alertController.preferredAction = settingsButton
        return alertController
    }
    
    static func actionSheetSourceSelection(cameraAction: Action?, libraryAction: Action?) -> UIAlertController {
        let alertController = UIAlertController(title: R.string.localizable.photoAlertViewControllerTitle(), message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: R.string.localizable.photoAlertViewControllerCameraTitle(), style: .default, handler: { _ in
            guard let cameraAction = cameraAction else { return }
            AnalyticsService.log(.photoDialog(source: .camera))
            cameraAction()
        })
        let libraryAction = UIAlertAction(title: R.string.localizable.photoAlertViewControllerLibraryTitle(), style: .default, handler: { _ in
            guard let libraryAction = libraryAction else { return }
            AnalyticsService.log(.photoDialog(source: .lib))
            libraryAction()
        })
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: { (_) in
            AnalyticsService.log(.photoDialog(source: .cancel))
        })
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        return alertController
    }
    
}
