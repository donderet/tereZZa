const std = @import("std");

pub extern "kernel32" fn SetConsoleOutputCP(wCodePageId: u32) callconv(std.os.windows.WINAPI) std.os.windows.BOOL;

pub fn main() !void {
    _ = SetConsoleOutputCP(65001);
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    defer _ = arena.deinit();
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    if (args.len == 5 and std.mem.eql(u8, args[1], "init")) {
        try @import("dummy_generator.zig").generate(allocator, args[2], args[3], args[4]);
        return;
    } else if (args.len == 3) {
        try @import("date_spoofer.zig").change_date(allocator, args[1], args[2]);
        return;
    }
    std.log.err("Невірна кількість аргументів", .{});
    try print_help();
}

pub fn print_help() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Використання:\n\tСтворення: tereZZa init <шлях> <КП-31|КП-32|КП-33> <назва роботи>\n\tЗміна часу: tereZZa <шлях> <yyyy-mm-ddThh:mm:ssZ>", .{});
}
