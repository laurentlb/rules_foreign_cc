load("@bazel_skylib//lib:types.bzl", "types")
load("//tools/build_defs/shell_toolchain/toolchains:commands.bzl", "PLATFORM_COMMANDS")
load(":function_helper.bzl", "FunctionAndCall")

_function_and_call_type = type(FunctionAndCall(text = ""))

def create_context(ctx):
    return struct(
        shell = ctx.toolchains["@rules_foreign_cc//tools/build_defs/shell_toolchain/toolchains:shell_commands"].data,
        prelude = {},
    )

def call_shell(shell_context, method_, *args):
    """ Calls the 'method_' shell command from the toolchain.
 Checks the number and types of passed arguments.
 If the command returns the resulting text wrapped into FunctionAndCall provider,
 puts the text of the function into the 'prelude' dictionary in the 'shell_context',
 and returns only the call of that function.
"""
    func_ = getattr(shell_context.shell, method_)
    descriptor = PLATFORM_COMMANDS[method_]
    args_info = descriptor.arguments

    args_list = args[0] if len(args) > 0 else []
    if type(args_list) != type([]):
        args_list = args

    if len(args_list) != len(args_info):
        fail("Wrong number ({}) of arguments ({}) in a call to '{}'".format(
            len(args_list),
            str(args_list),
            method_,
        ))

    for idx in range(0, len(args_list)):
        if type(args_list[idx]) != args_info[idx].type_:
            fail("Wrong argument '{}' type: '{}'".format(args_info[idx].name, type(args_list[idx])))

    result = func_(*args_list)

    if type(result) == _function_and_call_type:
        if not shell_context.prelude.get(method_):
            define_function = getattr(shell_context.shell, "define_function")
            shell_context.prelude[method_] = define_function(method_, result.text)
        if hasattr(result, "call"):
            return result.call
        return " ".join([method_] + [_wrap_if_needed(str(arg)) for arg in args_list])

    return result

def _wrap_if_needed(arg):
    return "\"" + arg + "\"" if arg.find(" ") >= 0 else arg
