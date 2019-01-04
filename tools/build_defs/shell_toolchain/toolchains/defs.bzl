load(
    "//tools/build_defs/shell_toolchain/polymorphism:generate_overloads.bzl",
    "id_from_file",
)
load("//tools/build_defs/shell_toolchain/toolchains:toolchain_data.bzl", "toolchain_data")
load(":toolchain_mappings.bzl", "TOOLCHAIN_MAPPINGS")

def build_part(toolchain_type_):
    for item in TOOLCHAIN_MAPPINGS:
        file = item.file
        (before, separator, after) = file.partition(":")
        file_name = id_from_file(after)

        toolchain_data(
            name = file_name + "_data",
            file_name = file_name,
            visibility = ["//visibility:public"],
        )
        native.toolchain(
            name = file_name,
            toolchain_type = toolchain_type_,
            toolchain = file_name + "_data",
            exec_compatible_with = item.exec_compatible_with,
            target_compatible_with = item.target_compatible_with,
        )
