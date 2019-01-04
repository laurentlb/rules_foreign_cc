load("@commands_overloads//:toolchain_data_defs.bzl", "get")

def _toolchain_data(ctx):
    return platform_common.ToolchainInfo(data = get(ctx.attr.file_name))

toolchain_data = rule(
    implementation = _toolchain_data,
    attrs = {
        "file_name": attr.string(),
    },
)
