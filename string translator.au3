#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <String.au3>
#include <WindowsConstants.au3>

$Form2 = GUICreate("string Translate", 635, 346, 193, 125)
$Label_input = GUICtrlCreateLabel("Text to Translate:", 10, 10, 87, 17)
$Edit_input = GUICtrlCreateEdit("", 10, 30, 611, 116)

$label_icon_paste = GUICtrlCreateLabel("<", 598, 152, 10, 18)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$icon_paste = GUICtrlCreateIcon("C:\Windows\System32\shell32.dll", -261, 607, 150, 16, 16)
GUICtrlSetTip(-1, "paste from clipboard")

$label_icon_copy = GUICtrlCreateLabel(">", 597, 312, 10, 18)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$icon_copy = GUICtrlCreateIcon("C:\Windows\System32\shell32.dll", -261, 607, 310, 16, 16)
GUICtrlSetTip(-1, "copy to clipboard")

$Label_output = GUICtrlCreateLabel("Translated Text:", 10, 165, 81, 17)
$Edit_output = GUICtrlCreateEdit("", 10, 189, 611, 116)

$Combo_src = GUICtrlCreateCombo("", 141, 157, 137, 25)
$Combo_dst = GUICtrlCreateCombo("", 358, 158, 137, 25)

$Icon_arrow = GUICtrlCreateIcon("C:\Windows\System32\shell32.dll", -300, 302, 152, 32, 32)

$button_translate = GUICtrlCreateButton("Translate", 280, 312, 75, 25)

Global $languages[109] = ['Afrikaans : af', 'Albanian : sq', 'Amharic : am', 'Arabic : ar', 'Armenian : hy', 'Azerbaijani : az', 'Basque : eu', 'Belarusian : be', 'Bengali : bn', 'Bosnian : bs', 'Bulgarian : bg', 'Catalan : ca', 'Cebuano : ceb', 'Chinese (Simplified) : zh-CN', 'Chinese (Traditional) : zh-TW', 'Corsican : co', 'Croatian : hr', 'Czech : cs', 'Danish : da', 'Dutch : nl', 'English : en', 'Esperanto : eo', 'Estonian : et', 'Finnish : fi', 'French : fr', 'Frisian : fy', 'Galician : gl', 'Georgian : ka', 'German : de', 'Greek : el', 'Gujarati : gu', 'Haitian Creole : ht', 'Hausa : ha', 'Hawaiian : haw', 'Hebrew : iw', 'Hindi : hi', 'Hmong : hmn', 'Hungarian : hu', 'Icelandic : is', 'Igbo : ig', 'Indonesian : id', 'Irish : ga', 'Italian : it', 'Japanese : ja', 'Javanese : jv', 'Kannada : kn', 'Kazakh : kk', 'Khmer : km', 'Kinyarwanda : rw', 'Korean : ko', 'Kurdish : ku', 'Kyrgyz : ky', 'Lao : lo', 'Latin : la', 'Latvian : lv', 'Lithuanian : lt', 'Luxembourgish : lb', 'Macedonian : mk', 'Malagasy : mg', 'Malay : ms', 'Malayalam : ml', 'Maltese : mt', 'Maori : mi', 'Marathi : mr', 'Mongolian : mn', 'Myanmar (Burmese) : my', 'Nepali : ne', 'Norwegian : no', 'Nyanja (Chichewa) : ny', 'Odia (Oriya) : or', 'Pashto : ps', 'Persian : fa', 'Polish : pl', 'Portuguese (Portugal, Brazil) : pt', 'Punjabi : pa', 'Romanian : ro', 'Russian : ru', 'Samoan : sm', 'Scots Gaelic : gd', 'Serbian : sr', 'Sesotho : st', 'Shona : sn', 'Sindhi : sd', 'Sinhala (Sinhalese) : si', 'Slovak : sk', 'Slovenian : sl', 'Somali : so', 'Spanish : es', 'Sundanese : su', 'Swahili : sw', 'Swedish : sv', 'Tagalog (Filipino) : tl', 'Tajik : tg', 'Tamil : ta', 'Tatar : tt', 'Telugu : te', 'Thai : th', 'Turkish : tr', 'Turkmen : tk', 'Ukrainian : uk', 'Urdu : ur', 'Uyghur : ug', 'Uzbek : uz', 'Vietnamese : vi', 'Welsh : cy', 'Xhosa : xh', 'Yiddish : yi', 'Yoruba : yo', 'Zulu : zu']
For $i = 0 To UBound($languages) - 1
    GUICtrlSetData($Combo_src, $languages[$i])
    GUICtrlSetData($Combo_dst, $languages[$i])
Next

GUICtrlSetData($Combo_src, 'English : en')
GUICtrlSetData($Combo_dst, 'Hebrew : iw')

HotKeySet("^{enter}", "translate")
GUISetState(@SW_SHOW)

While 1
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            Exit
        Case $button_translate
            translate()
        Case $icon_paste
            $clip = ClipGet()
            If $clip <> '' Then GUICtrlSetData($Edit_input, $clip)
;~             GUICtrlSetData($Edit_input, GUICtrlRead($Edit_input) & ClipGet())
        Case $icon_copy
            ClipPut(GUICtrlRead($Edit_output))
        Case $Combo_src
            If GUICtrlRead($Combo_src) = 'iw' Then GUICtrlSetStyle($Edit_input, BitOR($GUI_SS_DEFAULT_EDIT, $ES_RIGHT))
        Case $Icon_arrow
            $temp = GUICtrlRead($Combo_src)
            GUICtrlSetData($Combo_src, GUICtrlRead($Combo_dst))
            GUICtrlSetData($Combo_dst, $temp)
    EndSwitch
WEnd

Func translate()
    GUICtrlSetState($button_translate, $gui_disable)
    If StringStripWS(GUICtrlRead($Edit_input), 8) = '' Then Return
    $tmp_combo_src = GUICtrlRead($Combo_src)
    $tmp_combo_dst = GUICtrlRead($Combo_dst)
    If StringStripWS($tmp_combo_src, 8) = '' Or StringStripWS($tmp_combo_dst, 8) = '' Then Return

    If StringInStr($tmp_combo_src, ' : ') Then
        $src_lang = StringSplit(GUICtrlRead($Combo_src), ' : ', 1)[2]
    Else
        $src_lang = GUICtrlRead($Combo_src)
    EndIf

    If StringInStr($tmp_combo_dst, ' : ') Then
        $dst_lang = StringSplit(GUICtrlRead($Combo_dst), ' : ', 1)[2]
    Else
        $dst_lang = GUICtrlRead($Combo_dst)
    EndIf

    If $dst_lang = 'iw' Then GUICtrlSetStyle($Edit_output, BitOR($GUI_SS_DEFAULT_EDIT, $ES_RIGHT))

    $string = GUICtrlRead($Edit_input)
    $encoded_string = _urlEncode($string)
    $url = StringFormat("https://translate.google.com/m?sl=%s&tl=%s&q=%s", $src_lang, $dst_lang, $encoded_string)
    $inet_hex = InetRead($url, 1)
;~     $inet_string = _HexToString($inet_hex)
;~     $translation = _StringBetween($inet_string, '<div class="result-container">', '</div>')[0]

    $text_field = _StringBetween($inet_hex, '3C64697620636C6173733D22726573756C742D636F6E7461696E6572223E', '3C2F6469763E')[0]
    $translation = _HexToString($text_field)

    $translation = StringReplace($translation, "&#39;", "'")
    $translation = StringReplace($translation, "&quot;", '"')
    GUICtrlSetData($Edit_output, $translation)
    GUICtrlSetState($button_translate, $gui_enable)
EndFunc   ;==>translate


Func _urlEncode($sData)
    Local $aData = StringSplit(BinaryToString(StringToBinary($sData, 4), 1), "")
    Local $nChar
    $sData = ""
    For $i = 1 To $aData[0]
        $nChar = Asc($aData[$i])
        Switch $nChar
            Case 45, 46, 48 To 57, 65 To 90, 95, 97 To 122, 126
                $sData &= $aData[$i]
            Case 32
                $sData &= "+"
            Case Else
                $sData &= "%" & Hex($nChar, 2)
        EndSwitch
    Next
    Return $sData
EndFunc   ;==>_urlEncode
