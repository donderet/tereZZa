const std = @import("std");
const win = std.os.windows;

pub const system_time_t = extern struct {
    wYear: win.WORD,
    wMonth: win.WORD,
    wDayOfWeek: win.WORD,
    wDay: win.WORD,
    wHour: win.WORD,
    wMinute: win.WORD,
    wSecond: win.WORD,
    wMilliseconds: win.WORD,
};

pub const tzi_t = extern struct {
    Bias: i32,
    StandardName: [32]u16,
    StandardDate: system_time_t,
    StandardBias: i32,
    DaylightName: [32]u16,
    DaylightDate: system_time_t,
    DaylightBias: i32,
};

pub extern "kernel32" fn GetSystemTime(
    lpSystemTime: *system_time_t,
) callconv(win.WINAPI) void;

pub extern "kernel32" fn SystemTimeToFileTime(
    lpSystemTime: *const system_time_t,
    lpFileTime: *win.FILETIME,
) callconv(win.WINAPI) win.BOOL;

pub extern "kernel32" fn GetTimeZoneInformation(
    lpTimeZoneInformation: ?*tzi_t,
) callconv(win.WINAPI) win.DWORD;

pub extern "kernel32" fn GetTimeZoneInformationForYear(
    wYear: u16,
    pdtzi: ?*anyopaque,
    ptzi: ?*tzi_t,
) callconv(win.WINAPI) win.BOOL;

pub extern "kernel32" fn TzSpecificLocalTimeToSystemTime(
    lpTimeZoneInformation: ?*const tzi_t,
    lpUniversalTime: ?*const system_time_t,
    lpLocalTime: ?*system_time_t,
) callconv(win.WINAPI) win.BOOL;
