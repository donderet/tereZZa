const std = @import("std");

pub fn generate(allocator: std.mem.Allocator, dir_str: []const u8, group: []const u8, work_type: []const u8) !void {
    if (std.mem.eql(u8, group, "КП-33")) {
        for (@import("students.zig").kp33) |student| {
            try gen_file(allocator, dir_str, group, work_type, student);
        }
    } else if (std.mem.eql(u8, group, "КП-32")) {
        for (@import("students.zig").kp32) |student| {
            try gen_file(allocator, dir_str, group, work_type, student);
        }
    } else if (std.mem.eql(u8, group, "КП-31")) {
        for (@import("students.zig").kp31) |student| {
            try gen_file(allocator, dir_str, group, work_type, student);
        }
    } else {
        std.log.err("Невідома група {s}", .{group});
        return;
    }
}

fn gen_file(allocator: std.mem.Allocator, dir_str: []const u8, group: []const u8, work_type: []const u8, student: []const u8) !void {
    const buf = try allocator.alloc(u8, dir_str.len + group.len + work_type.len + student.len + 7);
    _ = try std.fmt.bufPrint(buf, "{s}\\{s}_{s}_{s}.pdf", .{ dir_str, group, work_type, student });
    const file = try std.fs.cwd().createFile(buf, .{ .read = true });
    file.close();
}
