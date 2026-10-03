#Requires AutoHotkey v2.0
#SingleInstance Force

#HotIf WinActive("ahk_class CabinetWClass") ; Only active inside File Explorer
~^v:: {
    ; Check if clipboard has image data (CF_DIB = 8, CF_BITMAP = 2)
    if DllCall("IsClipboardFormatAvailable", "UInt", 8) || DllCall("IsClipboardFormatAvailable", "UInt", 2) {
        hwnd := WinExist("A")
        dir := ""
        
        ; Find active File Explorer folder path
        for window in ComObject("Shell.Application").Windows {
            try {
                if (window.hwnd == hwnd) {
                    dir := window.Document.Folder.Self.Path
                    break
                }
            }
        }
        
        if (dir != "") {
            timestamp := FormatTime(, "yyyy-MM-dd_HHmmss")
            filePath := dir "\Screenshot_" timestamp ".png"
            
            ; Save clipboard image to PNG via PowerShell (.NET)
            psCommand := "Add-Type -AssemblyName System.Windows.Forms; $img = [System.Windows.Forms.Clipboard]::GetImage(); if ($img) {$img.Save('" . filePath . "', [System.Drawing.Imaging.ImageFormat]::Png) }"
            RunWait("powershell -NoProfile -ExecutionPolicy Bypass -Command `"" psCommand "`"", , "Hide")
            
            ; Verify file creation and select it in File Explorer
            if FileExist(filePath) && FileGetSize(filePath) > 0 {
                try {
                    for window in ComObject("Shell.Application").Windows {
                        if (window.hwnd == hwnd) {
                            window.Document.SelectItem(filePath, 1 | 4 | 8)
                            break
                        }
                    }
                }
            }
        }
    }
}
#HotIf