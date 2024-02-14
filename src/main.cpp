#include <sese/util/Initializer.h>
#include <sese/record/Marco.h>

auto string = "World";

int main(int argc, char **argv) {
    sese::initCore(argc, argv);
    SESE_INFO("Hello, %s", string);
    return 0;
}