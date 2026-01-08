import ProjectDescription

let project = Project(
    name: "LockerDemoApp",
    organizationName: "com.locker",
    packages: [
        .local(path: "../../") // Locker 라이브러리를 로컬 패키지로 참조
    ],
    targets: [
        .target(
            name: "LockerDemoApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.locker.demo",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "Locker Demo",
                "UILaunchStoryboardName": "LaunchScreen",
                "LSSupportsOpeningDocumentsInPlace": true,
                "UISupportsDocumentBrowser": true,
            ]),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .package(product: "Locker", type: .runtime)
            ]
        )
    ]
)
