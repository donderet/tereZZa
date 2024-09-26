const std = @import("std");
const win = std.os.windows;
const wtime = @import("wintime.zig");

pub const ConvertionError = error{
    InvalidDate,
};

pub fn change_date(
    allocator: std.mem.Allocator,
    dir_str: []const u8,
    time_str: []const u8,
    date: ?[]const u8,
) !void {
    var file_time: win.FILETIME = undefined;
    toFileTime(
        time_str,
        date,
        &file_time,
    ) catch {
        std.log.err("Неправильний формат дати", .{});
    };

    var dir = try std.fs.cwd().openDir(
        dir_str,
        .{
            .iterate = true,
        },
    );
    defer dir.close();
    var walker = try dir.walk(allocator);
    defer walker.deinit();
    while (try walker.next()) |entry| {
        const path_w = try std.unicode.utf8ToUtf16LeAlloc(
            allocator,
            entry.basename,
        );
        defer allocator.free(path_w);
        const handle = win.OpenFile(path_w, .{
            .dir = dir.fd,
            .access_mask = win.GENERIC_READ | win.GENERIC_WRITE | win.SYNCHRONIZE,
            .creation = 1,
        }) catch {
            std.log.err("Неможливо відкрити файл {s}", .{entry.path});
            return;
        };
        defer win.CloseHandle(handle);
        win.SetFileTime(
            handle,
            &file_time,
            &file_time,
            &file_time,
        ) catch {
            std.log.err("Неможливо встановити час файлу {s}", .{entry.path});
        };
    }
}
/// Convert local date and time strings to Windows' FILETIME structure
/// Date format:
/// dd-MM-yyyy
/// Time format:
/// HH:mm
/// If date is null, current date will be used
fn toFileTime(
    time_str: []const u8,
    date: ?[]const u8,
    file_time_ptr: *win.FILETIME,
) !void {
    var system_time: wtime.system_time_t = undefined;
    var tzi: wtime.tzi_t = undefined;
    var local_time: wtime.system_time_t = undefined;
    var res: win.BOOL = undefined;

    wtime.GetSystemTime(&system_time);

    const parse = std.fmt.parseUnsigned;
    if (date) |date_str| {
        system_time.wDay = try parse(u16, date_str[0..2], 10);
        system_time.wMonth = try parse(u16, date_str[3..5], 10);
        system_time.wYear = try parse(u16, date_str[6..10], 10);
    }
    system_time.wHour = try parse(u16, time_str[0..2], 10);
    system_time.wMinute = try parse(u16, time_str[3..5], 10);

    res = wtime.GetTimeZoneInformationForYear(
        system_time.wYear,
        null,
        &tzi,
    );
    if (res == 0) return ConvertionError.InvalidDate;

    res = wtime.TzSpecificLocalTimeToSystemTime(
        &tzi,
        &system_time,
        &local_time,
    );
    if (res == 0) return ConvertionError.InvalidDate;

    res = wtime.SystemTimeToFileTime(
        &local_time,
        file_time_ptr,
    );
    if (res == 0) return ConvertionError.InvalidDate;
}
