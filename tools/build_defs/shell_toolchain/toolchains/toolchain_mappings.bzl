_ToolchainMapping = provider(
    doc = "TODO",
    fields = {
        "file": "",
        "exec_compatible_with": "",
        "target_compatible_with": "",
    },
)

TOOLCHAIN_MAPPINGS = [
    _ToolchainMapping(
        exec_compatible_with = [
            "@bazel_tools//platforms:linux",
            "@bazel_tools//platforms:x86_64",
        ],
        file = "@rules_foreign_cc//tools/build_defs/shell_toolchain/toolchains/impl:linux_commands.bzl",
        target_compatible_with = [
            "@bazel_tools//platforms:linux",
            "@bazel_tools//platforms:x86_64",
        ],
    ),
    _ToolchainMapping(
        exec_compatible_with = [
            "@bazel_tools//platforms:osx",
            "@bazel_tools//platforms:x86_64",
        ],
        file = "@rules_foreign_cc//tools/build_defs/shell_toolchain/toolchains/impl:osx_commands.bzl",
        # todo probably keep only execution info
        target_compatible_with = [
            "@bazel_tools//platforms:osx",
            "@bazel_tools//platforms:x86_64",
        ],
    ),
]
