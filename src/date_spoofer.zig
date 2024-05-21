const std = @import("std");
const date = @import("date.zig");
const win = std.os.windows;

pub fn change_date(allocator: std.mem.Allocator, dir_str: []const u8, date_str: []const u8) !void {
    const desired_date: date.DateTime = date.parseIso8601ToDateTime(date_str) catch {
        std.log.err("Невідомий формат дати", .{});
        return;
    };
    const desired_timestamp = date.dateTimeToTimestamp(desired_date) catch {
        std.log.err("Невдалося конвертувати дату в таймштамп", .{});
        return;
    };
    const unix: i64 = desired_timestamp;
    const epoch: i64 = 116444736000000000;
    const timestamp: i64 = unix *% 10000000 +% epoch;
    const file_time: win.FILETIME = .{
        .dwLowDateTime = @bitCast(@as(i32, @truncate(timestamp))),
        .dwHighDateTime = @bitCast(@as(i32, @truncate(timestamp >> 32))),
    };

    var dir = try std.fs.cwd().openDir(dir_str, .{ .iterate = true });
    defer dir.close();
    var walker = try dir.walk(allocator);
    defer walker.deinit();
    while (try walker.next()) |entry| {
        const path_w = try std.unicode.utf8ToUtf16LeAlloc(allocator, entry.basename);
        const handle = win.OpenFile(path_w, .{
            .dir = dir.fd,
            .access_mask = win.GENERIC_READ | win.GENERIC_WRITE | win.SYNCHRONIZE,
            .creation = 1,
        }) catch {
            std.log.err("Неможливо відкрити файл {s}", .{entry.path});
            return;
        };
        defer win.CloseHandle(handle);
        win.SetFileTime(handle, null, &file_time, &file_time) catch {
            std.log.err("Неможливо встановити час файлу {s}", .{entry.path});
        };
    }
}
