// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        productTypes: [
            "Locker": .framework
        ]
    )
#endif

let package = Package(
    name: "LockerDemoApp",
    dependencies: []
)

