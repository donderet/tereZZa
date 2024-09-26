const std = @import("std");

pub extern "kernel32" fn SetConsoleOutputCP(
    wCodePageId: u32,
) callconv(std.os.windows.WINAPI) std.os.windows.BOOL;

pub fn main() !void {
    _ = SetConsoleOutputCP(65001);
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    defer _ = arena.deinit();
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    if (args.len >= 3) {
        const date = if (args.len > 3) args[3] else null;
        try @import("date_spoofer.zig").change_date(
            allocator,
            args[1],
            args[2],
            date,
        );
        return;
    }
    std.log.err("Неправильна кількість аргументів", .{});
    try print_help();
}

pub fn print_help() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Використання:\n\tЗміна часу: tereZZa <шлях> <HH:mm> [dd-MM-yyyy]\n", .{});
}
