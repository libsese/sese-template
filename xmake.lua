add_rules("mode.debug", "mode.release")

local registries = {
    {
        kind = "git",
        repository = "https://github.com/libsese/vcpkg-registry",
        baseline = "0113f7c41fd1444ecc975b49c1f750fe21c9118d",
        packages = {
            "sese-core"
        }
    }
}

add_requires("vcpkg::sese-core >=2.0.1", {configs = { shared = true, baseline = "c8696863d371ab7f46e213d8f5ca923c4aef2a00",registries = registries}})

set_languages("c++17")

target("template")
    set_kind("binary")
    add_files("src/*.cpp")
    add_packages("vcpkg::sese-core")

target("unittest")
    set_kind("binary")
    add_files("test/*.cpp")
    add_packages("vcpkg::sese-core")