#Requires AutoHotkey v2.0

; Global listener for scanner input ending with Enter
ih := InputHook("V")
ih.KeyOpt("{Enter}", "N")
ih.OnEnd := ProcessScan
ih.Start()

ProcessScan(ih) {
    if (ih.EndKey = "Enter") {
        ; Searches Google whenever the scan contains "Monster"
        if InStr(ih.Input, "Monster") {
            query := StrReplace(ih.Input, " ", "+")
            Run("https://www.google.com/search?q=" . query)
        }
    }
    ih.Start() ; Reset listener for next scan
}