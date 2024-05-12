add_rules("mode.debug", "mode.release")

local registries = {
    {
        kind = "git",
        repository = "https://github.com/libsese/vcpkg-registry",
        baseline = "43ed8eab2f54413ebd406ca2f9fcf17240995335",
        packages = {
            "sese"
        }
    }
}

add_requires("vcpkg::sese >=2.1.0", {configs = { shared = true, baseline = "c8696863d371ab7f46e213d8f5ca923c4aef2a00",registries = registries}})

set_languages("c++17")

target("template")
    set_kind("binary")
    add_files("src/*.cpp")
    add_packages("vcpkg::sese")

target("unittest")
    set_kind("binary")
    add_files("test/*.cpp")
    add_packages("vcpkg::sese")