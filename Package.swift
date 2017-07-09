import PackageDescription

let package = Package(
    name: "SchoolBackend",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2),
        .Package(url: "https://github.com/vapor/fluent-provider.git", majorVersion: 1),
        .Package(url: "https://github.com/vapor/leaf-provider.git", majorVersion: 1)
        //.Package(url: "https://github.com/vapor/mysql-provider.git", majorVersion: 2),
    ],
    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
        "Tests",
    ]
)

