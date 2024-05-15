add_rules("mode.debug", "mode.release")

local registries = {
    {
        kind = "git",
        repository = "https://github.com/libsese/vcpkg-registry",
        baseline = "73268778d5f796f188ca66f71536377b171ee37e",
        packages = {
            "sese"
        }
    }
}

add_requires("vcpkg::sese >=2.1.1", {configs = { shared = true, baseline = "c8696863d371ab7f46e213d8f5ca923c4aef2a00",registries = registries}})

set_languages("c++17")

target("template")
    set_kind("binary")
    add_files("src/*.cpp")
    add_packages("vcpkg::sese")

target("unittest")
    set_kind("binary")
    add_files("test/*.cpp")
    add_packages("vcpkg::sese")