variable "VERSION" {
    default = "2026.08.22"
}

group "release" {
    targets = ["dev"]
}

target "_common" {
    context    = "."
    dockerfile = "dockerfile"
    target   = "dev"
}

target "local-dev" {
    inherits = ["_common"]
    tags     = [
        "iut-student-workspace:latest",
    ]
}

target "release" {
    context    = "."
    dockerfile = "dockerfile"
    target   = "dev"
    args = {
        APP_VERSION = "${VERSION}"
    }
    platforms = ["linux/amd64", "linux/arm64"]
    tags     = [
        "donovanbroquin/iut-student-workspace:latest",
        "donovanbroquin/iut-student-workspace:${VERSION}"
    ]
}
