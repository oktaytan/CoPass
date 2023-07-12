//
//  ProfileWireframe.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import UIKit

protocol ProfileWireframeProtocol: AnyObject {
    func navigate(to route: Router.Profile)
}

final class ProfileWireframe: BaseWireframe, ProfileWireframeProtocol {
    
    static func prepare() -> ProfileVC {
        let view = ProfileVC(nibName: ProfileVC.className, bundle: nil)
        let wireframe = ProfileWireframe()
        let presenter = ProfilePresenter(ui: view, wireframe: wireframe, storage: CoStorage.shared)
        let provider = ProfileTableViewProviderImpl()
        view.inject(presenter: presenter, provider: provider)
        wireframe.view = view
        return view
    }
    
    func navigate(to route: Router.Profile) {
        switch route {
        case .goToUser:
            goToUser()
        case .goToSettings:
            goToSettings()
        case .goToSync:
            goToSync()
        case .goToNotifications:
            goToNotifications()
        case .openShare:
            openShare()
        case .openExportImport:
            openExportImport()
        case .openSendFeedback:
            openSendFeedback()
        case .goToHelp:
            goToHelp()
        case .goToLogin:
            goToLogin()
        }
    }
}

extension ProfileWireframe {
    private func goToUser() {
        let userVC = UserWireframe.prepare()
        forward(userVC, with: .push)
    }
    
    private func goToSettings() {
        let settingsVC = SettingsVC(nibName: SettingsVC.className, bundle: nil)
        forward(settingsVC, with: .push)
    }
    
    private func goToSync() {
        let syncVC = SyncCloudVC(nibName: SyncCloudVC.className, bundle: nil)
        forward(syncVC, with: .push)
    }
    
    private func goToNotifications() {
        let notificationsVC = NotificationsVC(nibName: NotificationsVC.className, bundle: nil)
        forward(notificationsVC, with: .push)
    }
    
    private func openShare() {
        let icon = UIImage(named: "appLogo")!
        let appName = AppConstants.appName
        
        let activityViewController = UIActivityViewController(activityItems: [icon, appName], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view.view // so that iPads won't crash
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        activityViewController.activityItemsConfiguration = [
            UIActivity.ActivityType.message
        ] as? UIActivityItemsConfigurationReading
        
        activityViewController.excludedActivityTypes = [ .airDrop, .print, .mail, .message, .postToTwitter, .sharePlay ]
        activityViewController.isModalInPresentation = true
        forward(activityViewController, with: .present(from: self.view))
    }
    
    private func openExportImport() {
        let exportImportVC = ExportVC(nibName: ExportVC.className, bundle: nil)
        forward(exportImportVC, with: .pageSheet(from: self.view, detent: .medium))
    }
    
    private func openSendFeedback() {
        let feedbackVC = FeedbackVC(nibName: FeedbackVC.className, bundle: nil)
        forward(feedbackVC, with: .pageSheet(from: self.view, detent: .medium))
    }
    
    private func goToHelp() {
        let helpVC = HelpVC(nibName: HelpVC.className, bundle: nil)
        forward(helpVC, with: .push)
    }
    
    private func goToLogin() {
        guard let window = AppDesign.Window else { return }
        let loginVC = LoginWireframe.prepare()
        AppWireframe.shared.setRootVC(vc: loginVC, window)
    }
}
