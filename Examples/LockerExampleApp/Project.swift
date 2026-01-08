import ProjectDescription

let project = Project(
    name: "LockerExampleApp",
    packages: [
        .local(path: "../../")
    ],
    targets: [
        .target(
            name: "LockerExampleApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.locker.example",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleDisplayName": "Locker Example",
                    "UILaunchStoryboardName": "LaunchScreen",
                    "UISupportedInterfaceOrientations": [
                        "UIInterfaceOrientationPortrait",
                        "UIInterfaceOrientationLandscapeLeft",
                        "UIInterfaceOrientationLandscapeRight"
                    ]
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .package(product: "Locker", type: .runtime)
            ]
        )
    ]
)

