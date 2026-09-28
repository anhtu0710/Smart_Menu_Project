Add-Type -AssemblyName System.Drawing
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$base = "c:\Users\ASUS\Downloads\Smart_Menu\Smart_Menu\backend\src\main\resources\menu-style"
$targetPath = "c:\Users\ASUS\Downloads\Smart_Menu\Smart_Menu\backend\target\classes\menu-style"
$W = 800
$H = 1100
$jsonPath = Join-Path $PSScriptRoot "menu_sample_texts.json"
$txt = [System.IO.File]::ReadAllText($jsonPath, [System.Text.Encoding]::UTF8) | ConvertFrom-Json

function SetupG($g) {
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
    $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
}

function DrawCenter($g, $text, $font, $brush, $cx, $y) {
    $sz = $g.MeasureString($text, $font)
    $g.DrawString($text, $font, $brush, [float]($cx - $sz.Width / 2), [float]$y)
}

function DrawRight($g, $text, $font, $brush, $rx, $y) {
    $sz = $g.MeasureString($text, $font)
    $g.DrawString($text, $font, $brush, [float]($rx - $sz.Width), [float]$y)
}

function DrawDots($g, $x1, $x2, $y, $col) {
    $b = New-Object System.Drawing.SolidBrush($col)
    for ($x = [int]$x1; $x -lt [int]$x2; $x += 7) {
        $g.FillRectangle($b, [float]$x, [float]($y - 3), 2.0, 2.0)
    }
    $b.Dispose()
}

function FillRR($g, $brush, $x, $y, $w, $h, $r) {
    $p = New-Object System.Drawing.Drawing2D.GraphicsPath
    $p.AddArc([float]$x, [float]$y, [float]($r * 2), [float]($r * 2), 180, 90)
    $p.AddArc([float]($x + $w - $r * 2), [float]$y, [float]($r * 2), [float]($r * 2), 270, 90)
    $p.AddArc([float]($x + $w - $r * 2), [float]($y + $h - $r * 2), [float]($r * 2), [float]($r * 2), 0, 90)
    $p.AddArc([float]$x, [float]($y + $h - $r * 2), [float]($r * 2), [float]($r * 2), 90, 90)
    $p.CloseFigure()
    $g.FillPath($brush, $p)
    $p.Dispose()
}

function StrokeRR($g, $pen, $x, $y, $w, $h, $r) {
    $p = New-Object System.Drawing.Drawing2D.GraphicsPath
    $p.AddArc([float]$x, [float]$y, [float]($r * 2), [float]($r * 2), 180, 90)
    $p.AddArc([float]($x + $w - $r * 2), [float]$y, [float]($r * 2), [float]($r * 2), 270, 90)
    $p.AddArc([float]($x + $w - $r * 2), [float]($y + $h - $r * 2), [float]($r * 2), [float]($r * 2), 0, 90)
    $p.AddArc([float]$x, [float]($y + $h - $r * 2), [float]($r * 2), [float]($r * 2), 90, 90)
    $p.CloseFigure()
    $g.DrawPath($pen, $p)
    $p.Dispose()
}

function DrawRow($g, $name, $price, $desc, $x, $y, $maxW, $fN, $fP, $fD, $bN, $bP, $bD, $dotC) {
    $pSz = $g.MeasureString($price, $fP)
    $priceX = [float]($x + $maxW - $pSz.Width - 2)
    $nSz = $g.MeasureString($name, $fN)
    $g.DrawString($name, $fN, $bN, [float]($x + 14), [float]$y)
    $g.DrawString($price, $fP, $bP, $priceX, [float]$y)
    $d1 = [float]($x + 16 + $nSz.Width)
    $d2 = [float]($priceX - 5)
    if ($d2 -gt $d1) { DrawDots $g $d1 $d2 ($y + 10) $dotC }
    if ($desc -ne "") { $g.DrawString($desc, $fD, $bD, [float]($x + 14), [float]($y + 20)) }
}

function EnsureDir($path) {
    if (-not (Test-Path $path)) { New-Item -ItemType Directory -Path $path | Out-Null }
}

function SaveSample($bmp, $styleId, $fileName) {
    EnsureDir "$base\$styleId"
    $out = "$base\$styleId\$fileName"
    $bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
    Write-Host "   Da luu: $styleId/$fileName  ${W}x${H}"
    if (Test-Path $targetPath) {
        EnsureDir "$targetPath\$styleId"
        Copy-Item $out "$targetPath\$styleId\$fileName" -Force
    }
}

# ======================================================================
# 1. HIEN_DAI / sample_2 - Specialty Matcha va Cold Brew
# ======================================================================
Write-Host "==> Tao HIEN_DAI/sample_2.png..."
$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = [System.Drawing.Graphics]::FromImage($bmp)
SetupG $g

$rect = New-Object System.Drawing.Rectangle(0, 0, $W, $H)
$grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect,
    [System.Drawing.Color]::FromArgb(255, 8, 14, 28),
    [System.Drawing.Color]::FromArgb(255, 15, 23, 42),
    [System.Drawing.Drawing2D.LinearGradientMode]::Vertical)
$g.FillRectangle($grad, 0, 0, $W, $H)
$grad.Dispose()

$cyan = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 56, 189, 248))
$amber = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 245, 158, 11))
$white = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 248, 250, 252))
$mute = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 148, 163, 184))
$slate = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(180, 30, 41, 59))
$dotC = [System.Drawing.Color]::FromArgb(90, 56, 189, 248)

$g.FillRectangle($cyan, 0, 0, $W, 8)
$g.FillRectangle($cyan, 0, $H - 8, $W, 8)

$fTag = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$fTitle = New-Object System.Drawing.Font("Segoe UI", 28, [System.Drawing.FontStyle]::Bold)
$fSub = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Regular)
$fCat = New-Object System.Drawing.Font("Segoe UI", 15, [System.Drawing.FontStyle]::Bold)
$fItem = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
$fDesc = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Italic)
$fCombo = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
$fPrice = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)

DrawCenter $g "SPECIALTY BAR  |  MATCHA VA COLD BREW" $fTag $cyan ($W / 2) 36
DrawCenter $g "NEON SLATE CAFE" $fTitle $white ($W / 2) 68
DrawCenter $g "Thuc don matcha Uji, cold brew 18h va nitro" $fSub $mute ($W / 2) 112

$g.FillRectangle($cyan, 90, 146, $W - 180, 3)

FillRR $g $slate 40 168 ($W - 80) 430 16
$g.DrawString("MATCHA SIGNATURE" , $fCat, $cyan, 58, 186)
$items1 = @(
    @("Uji Matcha Latte", "58.000d", "Bot matcha grade A, sua yen mach, bot vang nhe"),
    @("Iced Ceremonial Matcha", "72.000d", "Matcha ceremonial, nuoc 80C, da vien trong"),
    @("Matcha Cloud Cheese", "65.000d", "Matcha dam, kem cheese muoi beo, bot matcha"),
    @("Hojicha Roasted Latte", "55.000d", "La tra rang Nhat, sua tuoi, hau vi hat de"),
    @("Yuzu Matcha Sparkling", "62.000d", "Matcha, yuzu tuoi, soda lanh, vo chanh")
)
$y = 224
foreach ($it in $items1) {
    DrawRow $g $it[0] $it[1] $it[2] 48 $y ($W - 96) $fItem $fItem $fDesc $white $amber $mute $dotC
    $y += 70
}

FillRR $g $slate 40 616 ($W - 80) 290 16
$g.DrawString("COLD BREW VA NITRO", $fCat, $cyan, 58, 634)
$items2 = @(
    @("Cold Brew 18 Gio", "49.000d", "Arabica Cau Dat ngam lanh, hau vi chocolate"),
    @("Nitro Cold Brew", "59.000d", "Bom nito, cream cascade, khong da"),
    @("Orange Cold Brew Tonic", "55.000d", "Cold brew, tonic, cam tuoi, vo cam")
)
$y = 672
foreach ($it in $items2) {
    DrawRow $g $it[0] $it[1] $it[2] 48 $y ($W - 96) $fItem $fItem $fDesc $white $amber $mute $dotC
    $y += 70
}

$promoBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(220, 2, 132, 199))
FillRR $g $promoBg 40 926 ($W - 80) 110 16
$promoBg.Dispose()
$g.DrawString("COMBO AFTERNOON FOCUS", $fTag, $white, 58, 942)
$g.DrawString("01 Uji Matcha Latte + 01 Croissant Bo", $fCombo, $white, 58, 968)
DrawRight $g "89.000d" $fPrice $amber ($W - 54) 960
$g.DrawString("Tiet kiem 24.000d  |  13:00 - 17:00 hang ngay", $fDesc, $white, 58, 998)

SaveSample $bmp "HIEN_DAI" "sample_2.png"
$g.Dispose(); $bmp.Dispose()
$cyan.Dispose(); $amber.Dispose(); $mute.Dispose(); $slate.Dispose()

# ======================================================================
# 2. SANG_TRONG / sample_2 - Afternoon High Tea
# ======================================================================
Write-Host "==> Tao SANG_TRONG/sample_2.png..."
$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = [System.Drawing.Graphics]::FromImage($bmp)
SetupG $g

$rect = New-Object System.Drawing.Rectangle(0, 0, $W, $H)
$grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect,
    [System.Drawing.Color]::FromArgb(255, 28, 25, 23),
    [System.Drawing.Color]::FromArgb(255, 41, 37, 36),
    [System.Drawing.Drawing2D.LinearGradientMode]::Vertical)
$g.FillRectangle($grad, 0, 0, $W, $H)
$grad.Dispose()

$gold = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 251, 191, 36))
$cream = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 254, 243, 199))
$stone = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 168, 162, 158))
$ink = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 245, 245, 244))
$dotG = [System.Drawing.Color]::FromArgb(120, 251, 191, 36)

$penGold = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 251, 191, 36), 2.0)
$g.DrawRectangle($penGold, 28, 28, $W - 56, $H - 56)
$penInner = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(120, 254, 243, 199), 1.0)
$g.DrawRectangle($penInner, 38, 38, $W - 76, $H - 76)
$penGold.Dispose(); $penInner.Dispose()

$fSerifT = New-Object System.Drawing.Font("Georgia", 26, [System.Drawing.FontStyle]::Bold)
$fSerifS = New-Object System.Drawing.Font("Georgia", 12, [System.Drawing.FontStyle]::Italic)
$fSerifC = New-Object System.Drawing.Font("Georgia", 14, [System.Drawing.FontStyle]::Bold)
$fSerifI = New-Object System.Drawing.Font("Georgia", 12.5, [System.Drawing.FontStyle]::Bold)
$fSerifD = New-Object System.Drawing.Font("Georgia", 10, [System.Drawing.FontStyle]::Italic)

DrawCenter $g "ROYAL SALON  -  AFTERNOON TEA" $fTag $gold ($W / 2) 58
DrawCenter $g "MAJESTIC GOLD" $fSerifT $cream ($W / 2) 92
DrawCenter $g "High tea, espresso martini va petit fours" $fSerifS $stone ($W / 2) 136

$g.DrawString("PETIT FOURS VA SAVORIES", $fSerifC, $gold, 62, 178)
$lux1 = @(
    @("Smoked Salmon Finger", "95.000d", "Banh mi brio, ca hoi xong khoi, dill"),
    @("Truffle Egg Sandwich", "88.000d", "Trung luoc, mayo tartufo, microgreen"),
    @("Mini Beef Wellington", "125.000d", "Thit bo Wagyu, nam, vo puff"),
    @("Lemon Curd Tartlet", "72.000d", "Vo shortcrust, curd chanh, merengue")
)
$y = 214
foreach ($it in $lux1) {
    DrawRow $g $it[0] $it[1] $it[2] 52 $y ($W - 104) $fSerifI $fSerifI $fSerifD $ink $gold $stone $dotG
    $y += 62
}

$g.DrawString("SIGNATURE DRINKS", $fSerifC, $gold, 62, 478)
$lux2 = @(
    @("Earl Grey Royal", "68.000d", "Tra Earl Grey, hoa nhai, sua yen"),
    @("Espresso Martini Gold", "145.000d", "Vodka, espresso, siro vani, la vang"),
    @("Champagne Afternoon", "189.000d", "Prosecco, siro elderflower, dao"),
    @("Velvet Hot Chocolate", "79.000d", "Cacao 70%, kem tuoi, marshmallow")
)
$y = 514
foreach ($it in $lux2) {
    DrawRow $g $it[0] $it[1] $it[2] 52 $y ($W - 104) $fSerifI $fSerifI $fSerifD $ink $gold $stone $dotG
    $y += 62
}

$luxBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 69, 26, 3))
FillRR $g $luxBg 52 780 ($W - 104) 150 8
$luxBg.Dispose()
DrawCenter $g "HIGH TEA FOR TWO" $fSerifC $gold ($W / 2) 800
$g.DrawString("02 Signature drinks + 1 tower petit fours", $fSerifI, $cream, 70, 840)
DrawRight $g "459.000d" $fPrice $gold ($W - 70) 834
$g.DrawString("Dat truoc 2 gio  |  Phuc vu 14:00 - 17:30", $fSerifD, $stone, 70, 880)

DrawCenter $g "Fine dining lounge  |  Dress code smart casual" $fSerifS $stone ($W / 2) 980
DrawCenter $g "Mo cua 10:00 - 23:00  |  Hotline 1900 2424" $fSerifD $stone ($W / 2) 1014

SaveSample $bmp "SANG_TRONG" "sample_2.png"
$g.Dispose(); $bmp.Dispose()
$gold.Dispose(); $cream.Dispose(); $stone.Dispose(); $ink.Dispose()

# ======================================================================
# 3. TRE_TRUNG / sample_2 - Korean dessert cafe
# ======================================================================
Write-Host "==> Tao TRE_TRUNG/sample_2.png..."
$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = [System.Drawing.Graphics]::FromImage($bmp)
SetupG $g

$g.Clear([System.Drawing.Color]::FromArgb(255, 255, 240, 245))
$rose = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 219, 39, 119))
$deep = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 131, 24, 67))
$card = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 228, 225))
$pink = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 251, 207, 232))
$txt = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 80, 20, 50))
$dotP = [System.Drawing.Color]::FromArgb(140, 244, 114, 182)

FillRR $g $rose 48 36 ($W - 96) 88 26
DrawCenter $g "SOO CAFE  -  DESSERT LAB" $fTitle $white ($W / 2) 56

FillRR $g $card 40 148 ($W - 80) 430 24
$g.DrawString("BINGSU VA SOFT SERVE", $fCat, $rose, 62, 168)
$cute1 = @(
    @("Strawberry Bingsu", "89.000d", "Da tuyet, dau Han, sua dac, marshmallow"),
    @("Injeolmi Soft Serve", "75.000d", "Kem mem, bot dau nanh, mochi"),
    @("Tiramisu Bingsu", "95.000d", "Da espresso, mascarpone, cacao"),
    @("Mango Coconut Bowl", "82.000d", "Xoai chin, dua, hat chia, granola"),
    @("Chocolate Fondue Cup", "79.000d", "Kem vani, chocolate 55%, chuoi")
)
$y = 208
foreach ($it in $cute1) {
    DrawRow $g $it[0] $it[1] $it[2] 48 $y ($W - 96) $fItem $fItem $fDesc $deep $rose $txt $dotP
    $y += 70
}

FillRR $g $card 40 598 ($W - 80) 250 24
$g.DrawString("DRINKS DE NGUOI TRE", $fCat, $rose, 62, 616)
$cute2 = @(
    @("Brown Sugar Milk Tea", "52.000d", "Duong nau nuong, tran chau den"),
    @("Peach Ade Sparkling", "48.000d", "Dao ngam, soda, thach dao"),
    @("Taro Cream Smoothie", "55.000d", "Khoai mon, kem tuoi, bot khoai")
)
$y = 654
foreach ($it in $cute2) {
    DrawRow $g $it[0] $it[1] $it[2] 48 $y ($W - 96) $fItem $fItem $fDesc $deep $rose $txt $dotP
    $y += 60
}

FillRR $g $pink 40 868 ($W - 80) 130 24
DrawCenter $g "CHECK-IN COMBO" $fCat $rose ($W / 2) 884
$g.DrawString("01 Bingsu 2 nguoi + 02 Peach Ade", $fCombo, $deep, 62, 924)
DrawRight $g "169.000d" $fPrice $rose ($W - 58) 916
$g.DrawString("Tang photocard  |  Decor neon de chup", $fDesc, $txt, 62, 958)

SaveSample $bmp "TRE_TRUNG" "sample_2.png"
$g.Dispose(); $bmp.Dispose()
$rose.Dispose(); $deep.Dispose(); $card.Dispose(); $pink.Dispose(); $txt.Dispose()

# ======================================================================
# 4. TRUYEN_THONG / sample_2 - Che va do uong Viet
# ======================================================================
Write-Host "==> Tao TRUYEN_THONG/sample_2.png..."
$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = [System.Drawing.Graphics]::FromImage($bmp)
SetupG $g

$g.Clear([System.Drawing.Color]::FromArgb(255, 251, 240, 217))
$sepia = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 120, 53, 15))
$brown = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 68, 26, 8))
$amberT = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 180, 83, 9))
$warm = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 150, 130, 100))
$dotT = [System.Drawing.Color]::FromArgb(255, 200, 170, 120)
$panel = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 244, 228, 188))

$penBr = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 120, 53, 15), 3.0)
$g.DrawRectangle($penBr, 24, 24, $W - 48, $H - 48)
$penBr2 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 180, 83, 9), 1.2)
$g.DrawRectangle($penBr2, 34, 34, $W - 68, $H - 68)
$penBr.Dispose(); $penBr2.Dispose()

$fTtg = New-Object System.Drawing.Font("Georgia", 11, [System.Drawing.FontStyle]::Italic)
$fTtt = New-Object System.Drawing.Font("Georgia", 24, [System.Drawing.FontStyle]::Bold)
$fTct = New-Object System.Drawing.Font("Georgia", 14, [System.Drawing.FontStyle]::Bold)
$fTmn = New-Object System.Drawing.Font("Georgia", 12.5, [System.Drawing.FontStyle]::Bold)
$fTdc = New-Object System.Drawing.Font("Georgia", 10, [System.Drawing.FontStyle]::Italic)

DrawCenter $g "- Hang Che San Vuon -" $fTtg $sepia ($W / 2) 52
DrawCenter $g "HUONG VI QUE NHA" $fTtt $brown ($W / 2) 82
DrawCenter $g "Che, tau hu, nuoc giai khat thu cong" $fTtg $sepia ($W / 2) 122

$g.DrawString("CHE TRUYEN THONG", $fTct, $brown, 56, 164)
$tr1 = @(
    @("Che Ba Mau Sai Gon", "32.000d", "Dau xanh, dau do, rau cau, cot dua"),
    @("Che Chuoi Nuong", "35.000d", "Chuoi sot duong thang, dua, me"),
    @("Che Thai Sai Gon", "38.000d", "Mit, nhan, thach, sua dac, da bao"),
    @("Che Troi Nuoc Gung", "30.000d", "Banh troi dau xanh, nuoc gung am"),
    @("Tau Hu Nuoc Duong Gung", "28.000d", "Tau hu mem, duong phen, gung")
)
$y = 198
foreach ($it in $tr1) {
    DrawRow $g $it[0] $it[1] $it[2] 48 $y ($W - 96) $fTmn $fTmn $fTdc $brown $amberT $warm $dotT
    $y += 58
}

$g.DrawString("NUOC GIAI KHAT NHA LAM", $fTct, $brown, 56, 500)
$tr2 = @(
    @("Nuoc Dua Tac Mat Ong", "29.000d", "Dua tac, mat ong, da vien"),
    @("Sua Dau Nanh Nong", "22.000d", "Dau nanh xay tuoi, duong phen"),
    @("Nuoc Cam Vat", "32.000d", "Cam Sanh vat tay, khong da dam"),
    @("Tra Atiso Da Lat", "28.000d", "Hoa atiso say, lanh hoac nong")
)
$y = 534
foreach ($it in $tr2) {
    DrawRow $g $it[0] $it[1] $it[2] 48 $y ($W - 96) $fTmn $fTmn $fTdc $brown $amberT $warm $dotT
    $y += 58
}

FillRR $g $panel 52 780 ($W - 104) 140 8
DrawCenter $g "- Combo Chieu Mat -" $fTct $brown ($W / 2) 798
$g.DrawString("01 Che Ba Mau + 01 Tra Atiso Da Lat", $fTmn, $brown, 70, 838)
DrawRight $g "52.000d" $fPrice $amberT ($W - 70) 832
$g.DrawString("Phuc vu ca ngay  |  An tai quan hoac mang ve", $fTdc, $warm, 70, 876)

DrawCenter $g "Mo cua 08:00 - 21:00  |  San vuon  |  1900 3333" $fTdc $warm ($W / 2) 980

SaveSample $bmp "TRUYEN_THONG" "sample_2.png"
$g.Dispose(); $bmp.Dispose()
$sepia.Dispose(); $brown.Dispose(); $amberT.Dispose(); $warm.Dispose(); $panel.Dispose()

# ======================================================================
# 5. MINIMAL / sample_1 - Pour-over linen cafe
# ======================================================================
Write-Host "==> Tao MINIMAL/sample_1.png..."
$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = [System.Drawing.Graphics]::FromImage($bmp)
SetupG $g

$g.Clear([System.Drawing.Color]::FromArgb(255, 250, 248, 244))
$espresso = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 30, 28, 26))
$copper = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 180, 140, 75))
$taupe = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 120, 96, 64))
$linen = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 246, 242, 235))
$dotM = [System.Drawing.Color]::FromArgb(160, 205, 195, 180)

$penM = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 180, 140, 75), 1.4)
$g.DrawRectangle($penM, 36, 36, $W - 72, $H - 72)
$penM2 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(160, 205, 195, 180), 1.0)
$g.DrawRectangle($penM2, 44, 44, $W - 88, $H - 88)
$penM.Dispose(); $penM2.Dispose()

$fMtitle = New-Object System.Drawing.Font("Georgia", 28, [System.Drawing.FontStyle]::Regular)
$fMsub = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Regular)
$fMcat = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)

DrawCenter $g "THE LINEN ROOM" $fMtitle $espresso ($W / 2) 72
DrawCenter $g "pour-over  -  pastry  -  quiet hours" $fMsub $copper ($W / 2) 118
$g.FillEllipse($copper, ($W / 2 - 4), 148, 8, 8)

$g.DrawString("FILTER COFFEE", $fMcat, $copper, 64, 178)
$min1 = @(
    @("Ethiopia Natural V60", "75.000d", "Berry, jasmine, pour-over 28g"),
    @("Colombia Washed", "68.000d", "Caramel, citrus, Chemex"),
    @("Vietnam Honey Process", "62.000d", "Cau Dat, hau vi mat ong"),
    @("House Espresso", "45.000d", "Blend 70/30, chocolate, hat de"),
    @("Cortado / Flat White", "52.000d", "Sua tuoi, ti le ngan gon")
)
$y = 214
foreach ($it in $min1) {
    DrawRow $g $it[0] $it[1] $it[2] 52 $y ($W - 104) $fItem $fItem $fDesc $espresso $copper $taupe $dotM
    $y += 64
}

$g.DrawString("BAKERY", $fMcat, $copper, 64, 548)
$min2 = @(
    @("Butter Croissant", "38.000d", "Bo Phap, nuong 2 lan / ngay"),
    @("Almond Pain", "45.000d", "Hanh nhan, kem almond"),
    @("Sourdough Toast", "49.000d", "Bo, mat ong, muoi bien"),
    @("Banana Bread Slice", "42.000d", "Chuoi chin, oc cho")
)
$y = 584
foreach ($it in $min2) {
    DrawRow $g $it[0] $it[1] $it[2] 52 $y ($W - 104) $fItem $fItem $fDesc $espresso $copper $taupe $dotM
    $y += 58
}

FillRR $g $linen 56 830 ($W - 112) 120 10
DrawCenter $g "MORNING SET" $fMcat $copper ($W / 2) 848
$g.DrawString("01 V60 + 01 Croissant bo", $fItem, $espresso, 74, 884)
DrawRight $g "99.000d" $fPrice $copper ($W - 74) 876
$g.DrawString("07:00 - 11:00  |  Khong gian yen, wifi cham", $fDesc, $taupe, 74, 916)

DrawCenter $g "07:00 - 20:00  -  no loud calls  -  smartmenu.fnb.vn" $fMsub $taupe ($W / 2) 990

SaveSample $bmp "MINIMAL" "sample_1.png"
$g.Dispose(); $bmp.Dispose()
$espresso.Dispose(); $copper.Dispose(); $taupe.Dispose(); $linen.Dispose()

# ======================================================================
# 6. NHIET_DOI / sample_1 - Smoothie va juice bar
# ======================================================================
Write-Host "==> Tao NHIET_DOI/sample_1.png..."
$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = [System.Drawing.Graphics]::FromImage($bmp)
SetupG $g

$rect = New-Object System.Drawing.Rectangle(0, 0, $W, $H)
$grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect,
    [System.Drawing.Color]::FromArgb(255, 5, 42, 32),
    [System.Drawing.Color]::FromArgb(255, 10, 70, 52),
    [System.Drawing.Drawing2D.LinearGradientMode]::Vertical)
$g.FillRectangle($grad, 0, 0, $W, $H)
$grad.Dispose()

$goldN = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 245, 158, 11))
$creamN = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 254, 243, 199))
$mint = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 52, 211, 153))
$leaf = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(160, 8, 50, 38))
$dotN = [System.Drawing.Color]::FromArgb(90, 245, 158, 11)

$penN = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 245, 158, 11), 2.0)
StrokeRR $g $penN 24 24 ($W - 48) ($H - 48) 18
$penN.Dispose()

DrawCenter $g "FRESH 100%  -  NO SYRUP" $fTag $goldN ($W / 2) 48
DrawCenter $g "TROPICAL PRESS" $fTitle $creamN ($W / 2) 78
DrawCenter $g "Nuoc ep, smoothie va tra hoa qua tuoi" $fSub $mint ($W / 2) 122

FillRR $g $leaf 44 156 ($W - 88) 400 16
$g.DrawString("SMOOTHIE BOWL", $fCat, $mint, 62, 174)
$n1 = @(
    @("Green Detox", "69.000d", "Cai kale, tao xanh, chanh, gung"),
    @("Mango Sunrise", "65.000d", "Xoai chin, dua, chanh day"),
    @("Dragon Berry", "72.000d", "Thanh long, dau, chuoi, hat chia"),
    @("Avocado Cocoa", "75.000d", "Bo, cacao, sua hat, mat ong"),
    @("Pineapple Mint Crush", "62.000d", "Thom, bac ha, da xay")
)
$y = 214
foreach ($it in $n1) {
    DrawRow $g $it[0] $it[1] $it[2] 48 $y ($W - 96) $fItem $fItem $fDesc $creamN $goldN $mint $dotN
    $y += 64
}

FillRR $g $leaf 44 576 ($W - 88) 270 16
$g.DrawString("COLD PRESS JUICE", $fCat, $mint, 62, 594)
$n2 = @(
    @("Cam - Ca Rot - Gung", "58.000d", "Vitamin C, gung cay nhe"),
    @("Dua - Cai Xoan", "55.000d", "Dua tuoi, kale, tao"),
    @("Chanh Day - Tao", "52.000d", "Chanh day, tao Fuji, mat ong")
)
$y = 634
foreach ($it in $n2) {
    DrawRow $g $it[0] $it[1] $it[2] 48 $y ($W - 96) $fItem $fItem $fDesc $creamN $goldN $mint $dotN
    $y += 64
}

$deal = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(230, 180, 83, 9))
FillRR $g $deal 44 868 ($W - 88) 120 16
$deal.Dispose()
$g.DrawString("SUMMER DEAL", $fTag, $white, 62, 884)
$g.DrawString("01 Smoothie Bowl + 01 Cold Press", $fCombo, $white, 62, 916)
DrawRight $g "109.000d" $fPrice $creamN ($W - 58) 908
$g.DrawString("Giam 15%  |  10:00 - 16:00", $fDesc, $white, 62, 952)

SaveSample $bmp "NHIET_DOI" "sample_1.png"
$g.Dispose(); $bmp.Dispose()
$goldN.Dispose(); $creamN.Dispose(); $mint.Dispose(); $leaf.Dispose()
$white.Dispose()

Write-Host ""
Write-Host "===== HOAN TAT 6 MAU MENU MOI ====="
Write-Host "  HIEN_DAI/sample_2.png       - Matcha va Cold Brew"
Write-Host "  SANG_TRONG/sample_2.png     - Afternoon High Tea"
Write-Host "  TRE_TRUNG/sample_2.png      - Korean dessert cafe"
Write-Host "  TRUYEN_THONG/sample_2.png   - Che va nuoc giai khat"
Write-Host "  MINIMAL/sample_1.png        - Pour-over linen cafe"
Write-Host "  NHIET_DOI/sample_1.png      - Smoothie va juice bar"
