Add-Type -AssemblyName System.Drawing
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$base = "c:\Users\ASUS\Downloads\Smart_Menu\Smart_Menu\backend\src\main\resources\menu-style"

# ======================================================================
# HELPER FUNCTIONS
# ======================================================================
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
    $p.AddArc([float]$x, [float]$y, [float]($r*2), [float]($r*2), 180, 90)
    $p.AddArc([float]($x+$w-$r*2), [float]$y, [float]($r*2), [float]($r*2), 270, 90)
    $p.AddArc([float]($x+$w-$r*2), [float]($y+$h-$r*2), [float]($r*2), [float]($r*2), 0, 90)
    $p.AddArc([float]$x, [float]($y+$h-$r*2), [float]($r*2), [float]($r*2), 90, 90)
    $p.CloseFigure()
    $g.FillPath($brush, $p)
    $p.Dispose()
}

function StrokeRR($g, $pen, $x, $y, $w, $h, $r) {
    $p = New-Object System.Drawing.Drawing2D.GraphicsPath
    $p.AddArc([float]$x, [float]$y, [float]($r*2), [float]($r*2), 180, 90)
    $p.AddArc([float]($x+$w-$r*2), [float]$y, [float]($r*2), [float]($r*2), 270, 90)
    $p.AddArc([float]($x+$w-$r*2), [float]($y+$h-$r*2), [float]($r*2), [float]($r*2), 0, 90)
    $p.AddArc([float]$x, [float]($y+$h-$r*2), [float]($r*2), [float]($r*2), 90, 90)
    $p.CloseFigure()
    $g.DrawPath($pen, $p)
    $p.Dispose()
}

# Váº½ má»™t dĂ²ng menu: tĂªn mĂ³n, dáº¥u cháº¥m ná»‘i, giĂ¡ pháº£i
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

# ======================================================================
# 1. HIEN_DAI/sample_1.png - Hiá»‡n Äáº¡i: Thá»±c Ä‘Æ¡n CĂ  PhĂª Specialty
#    Ná»n tá»‘i navy Ä‘áº­m, accent xanh cyan, chá»¯ tráº¯ng, giĂ¡ vĂ ng amber
# ======================================================================
Write-Host "==> Táº¡o HIEN_DAI/sample_1.png..."
$W = 800; $H = 1100
$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = [System.Drawing.Graphics]::FromImage($bmp)
SetupG $g

# Ná»n navy Ä‘en Ä‘áº­m
$rect = New-Object System.Drawing.Rectangle(0, 0, $W, $H)
$grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect,
    [System.Drawing.Color]::FromArgb(255, 8, 14, 28),
    [System.Drawing.Color]::FromArgb(255, 15, 23, 42),
    [System.Drawing.Drawing2D.LinearGradientMode]::Vertical)
$g.FillRectangle($grad, 0, 0, $W, $H)
$grad.Dispose()

# Dáº£i accent cyan ngang Ä‘á»‰nh
$cyanBar = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 56, 189, 248))
$g.FillRectangle($cyanBar, 0, 0, $W, 6)
$cyanBar.Dispose()
$cyanBar2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 56, 189, 248))
$g.FillRectangle($cyanBar2, 0, [float]($H-6), $W, 6)
$cyanBar2.Dispose()

# Viá»n cyan má»ng bĂªn trong
$penCyan = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(60, 56, 189, 248), 1.0)
$g.DrawRectangle($penCyan, 22, 22, $W-44, $H-44)
$penCyan.Dispose()

# Fon va rush
$fLogo   = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$fTitle  = New-Object System.Drawing.Font("Segoe UI", 30, [System.Drawing.FontStyle]::Bold)
$fSub    = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Regular)
$fCat    = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
$fItem   = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
$fDesc   = New-Object System.Drawing.Font("Segoe UI", 10.5, [System.Drawing.FontStyle]::Italic)
$fSmall  = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Regular)

$bCyan   = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 56, 189, 248))
$bWhite  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 248, 250, 252))
$bAmber  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 245, 158, 11))
$bGray   = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 148, 163, 184))
$bSlate  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 100, 116, 139))
$dotHD   = [System.Drawing.Color]::FromArgb(255, 30, 58, 92)

# HEADER
DrawCenter $g "SPECIALTY COFFEE MENU" $fLogo $bCyan ($W/2) 38
DrawCenter $g "THE MODERN ESPRESSO BAR" $fTitle $bWhite ($W/2) 68
DrawCenter $g "Thá»±c ÄÆ¡n CĂ  PhĂª Äáº·c Sáº£n â€” Premium Coffee Experience" $fSub $bGray ($W/2) 110

# Thanh divider cyan phĂ¡t sĂ¡ng
$penDiv = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 56, 189, 248), 2.0)
$g.DrawLine($penDiv, 60, 132, $W-60, 132)
$penDiv.Dispose()
$g.FillEllipse($bCyan, [float]($W/2-4), 127.0, 9.0, 9.0)

# ---- DANH Má»¤C 1: CĂ€ PHĂ ESPRESSO ----
$secBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 15, 23, 42))
FillRR $g $secBg 40 150 ($W-80) 290 8
$secBg.Dispose()
StrokeRR $g (New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(120, 56, 189, 248), 1.0)) 40 150 ($W-80) 290 8

$penCatLine = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 56, 189, 248), 2.5)
$g.DrawLine($penCatLine, 60, 178, 78, 178)
$penCatLine.Dispose()
$g.DrawString("CĂ€ PHĂ ESPRESS va OUR OVER", $fCat, $bCyan, [float]84, [float]166)

$espressoMenu = @(
    @("Espresso Äáº·c Truyá»n",        "35.000Ä‘", "Single origin Ethiopia Yirgacheffe, háº­u vá»‹ cam quĂ½t tinh táº¿"),
    @("Flat White Sá»¯a Macadamia",   "55.000Ä‘", "Ristretto double shot, sá»¯a Macadamia rang thÆ¡m bĂ¹i"),
    @("Pour Over ÄÆ¡n Nguá»“n Gá»‘c",    "65.000Ä‘", "V60 hand drip, háº¡t Arabica Cáº§u Äáº¥t single origin"),
    @("Cortado TĂ¢y Ban Nha",        "48.000Ä‘", "Espress va teamed milk tá»‰ lá»‡ 1:1, Ä‘áº­m Ä‘Ă  thanh tao"),
    @("Cold Brew Nitro Ná»• BĂ³ng",    "58.000Ä‘", "Cold brew á»§ 20h, nitrogen infused, bá»t kem má»‹n mÆ°á»›t")
)
$ry = 195
foreach ($it in $espressoMenu) {
    DrawRow $g $it[0] $it[1] $it[2] 60 $ry ($W-120) $fItem $fItem $fDesc $bWhite $bAmber $bSlate $dotHD
    $ry += 52
}

# ---- DANH Má»¤C 2: ÄĂ XA va ATTE ----
$sec2Bg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 15, 23, 42))
FillRR $g $sec2Bg 40 458 ($W-80) 260 8
$sec2Bg.Dispose()
StrokeRR $g (New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(120, 56, 189, 248), 1.0)) 40 458 ($W-80) 260 8

$penCatLine2 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 245, 158, 11), 2.5)
$g.DrawLine($penCatLine2, 60, 486, 78, 486)
$penCatLine2.Dispose()
$g.DrawString("ÄĂ XAY SIGNATUR va ATTE", $fCat, $bAmber, [float]84, [float]474)

$lattMenu = @(
    @("Caramel Macchiato ÄĂ¡ Xay",   "62.000Ä‘", "Vanilla latte, caramel drizzle, Ä‘Ă¡ xay má»‹n nhÆ° kem"),
    @("Matcha Latte ÄĂ¡ Xay",        "60.000Ä‘", "Bá»™t trĂ  Uji Nháº­t Báº£n, kem tÆ°Æ¡i, vá»‹ Ä‘áº¯ng ngá»t cĂ¢n báº±ng"),
    @("Hazelnut Mocha Äen",         "58.000Ä‘", "Espresso, chocolate Ä‘en 70%, siroæ¦›æœ thÆ¡m háº¡t phá»‰"),
    @("Brown Sugar Milk Tea ÄĂ¡ Xay","55.000Ä‘", "ÄÆ°á»ng nĂ¢u caramel, trĂ¢n chĂ¢u nÆ°á»›ng, sá»¯a tÆ°Æ¡i thanh ngá»t")
)
$ry2 = 502
foreach ($it in $lattMenu) {
    DrawRow $g $it[0] $it[1] $it[2] 60 $ry2 ($W-120) $fItem $fItem $fDesc $bWhite $bAmber $bSlate $dotHD
    $ry2 += 52
}

# ---- COMBO ZONE ----
$comboBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 12, 30, 58))
FillRR $g $comboBg 40 734 ($W-80) 130 8
$comboBg.Dispose()
StrokeRR $g (New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 245, 158, 11), 1.5)) 40 734 ($W-80) 130 8

$badgeBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 245, 158, 11))
FillRR $g $badgeBg 60 720 180 28 14
$badgeBg.Dispose()
$fBadge = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$bDarkBadge = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 15, 23, 42))
$g.DrawString("DAILY COMBO DEAL", $fBadge, $bDarkBadge, [float]72, [float]730)
$fBadge.Dispose(); $bDarkBadge.Dispose()

$fComboName = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$fComboPrice = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Bold)
$g.DrawString("Combo Tinh Táº¿: 01 Pour Over + 01 BĂ¡nh Croissant Háº¡nh NhĂ¢n", $fComboName, $bWhite, [float]60, [float]756)
$g.DrawString("99.000Ä‘", $fComboPrice, $bAmber, [float]($W-185), [float]758)
$g.DrawString("Mua 2 thá»©c uá»‘ng báº¥t ká»³, giáº£m ngay 15%  Â·  Ăp dá»¥ng cĂ¡c ngĂ y trong tuáº§n", $fSmall, $bGray, [float]60, [float]796)
$g.DrawString("Topping: Kem tÆ°Æ¡i whip (+12k)  Â·  Espresso thĂªm shot (+15k)  Â·  Siro thĂªm vá»‹ (+8k)", $fSmall, $bGray, [float]60, [float]822)

# FOOTER
$penFoot = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 56, 189, 248), 1.5)
$g.DrawLine($penFoot, 60, 884, $W-60, 884)
$penFoot.Dispose()
DrawCenter $g "THE MODERN ESPRESSO BAR  Â·  Má»Ÿ cá»­a 07:00 â€“ 22:30" $fSub $bGray ($W/2) 910
DrawCenter $g "Hotline: 1900 6868  Â·  Wifi: Modern_Coffee (Pass: espresso2024)" $fSmall $bSlate ($W/2) 936

$bmp.Save("$base\HIEN_DAI\sample_1.png", [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host "   OK: HIEN_DAI/sample_1.png ($W x $H)"
$g.Dispose(); $bmp.Dispose()
$bCyan.Dispose(); $bWhite.Dispose(); $bAmber.Dispose(); $bGray.Dispose(); $bSlate.Dispose()


# ======================================================================
# 2. SANG_TRONG/sample_1.png - Sang Trá»ng: Thá»±c Ä‘Æ¡n Fine Dining Cocktail Bar
#    Ná»n Ä‘en espresso, vĂ ng 24K, khung Ä‘Ă´i hoĂ ng gia
# ======================================================================
Write-Host "==> Táº¡o SANG_TRONG/sample_1.png..."
$W = 900; $H = 1150
$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = [System.Drawing.Graphics]::FromImage($bmp)
SetupG $g

# Ná»n espresso Ä‘en sang trá»ng
$rect3 = New-Object System.Drawing.Rectangle(0, 0, $W, $H)
$grad3 = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect3,
    [System.Drawing.Color]::FromArgb(255, 18, 14, 12),
    [System.Drawing.Color]::FromArgb(255, 28, 22, 18),
    [System.Drawing.Drawing2D.LinearGradientMode]::Vertical)
$g.FillRectangle($grad3, 0, 0, $W, $H)
$grad3.Dispose()

# Khung vĂ ng hoĂ ng gia Ä‘Ă´i
$penGoldOut = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 251, 191, 36), 2.5)
$g.DrawRectangle($penGoldOut, 24, 24, $W-48, $H-48)
$penGoldOut.Dispose()
$penGoldIn = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 251, 191, 36), 1.0)
$g.DrawRectangle($penGoldIn, 34, 34, $W-68, $H-68)
$penGoldIn.Dispose()

# GĂ³c trang trĂ­ vĂ ng
$penCorner = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 251, 191, 36), 2.0)
$cs3 = 30
# TL
$g.DrawLine($penCorner, 44, 44, 44+$cs3, 44); $g.DrawLine($penCorner, 44, 44, 44, 44+$cs3)
# TR
$g.DrawLine($penCorner, $W-44-$cs3, 44, $W-44, 44); $g.DrawLine($penCorner, $W-44, 44, $W-44, 44+$cs3)
# BL
$g.DrawLine($penCorner, 44, $H-44-$cs3, 44, $H-44); $g.DrawLine($penCorner, 44, $H-44, 44+$cs3, $H-44)
# BR
$g.DrawLine($penCorner, $W-44-$cs3, $H-44, $W-44, $H-44); $g.DrawLine($penCorner, $W-44, $H-44-$cs3, $W-44, $H-44)
$penCorner.Dispose()

# Font va rushes SANG_TRONG
$fST_Title   = New-Object System.Drawing.Font("Georgia", 28, [System.Drawing.FontStyle]::Bold)
$fST_Royal   = New-Object System.Drawing.Font("Georgia", 12, [System.Drawing.FontStyle]::Italic)
$fST_Sub     = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Regular)
$fST_Cat     = New-Object System.Drawing.Font("Georgia", 14, [System.Drawing.FontStyle]::Bold)
$fST_Item    = New-Object System.Drawing.Font("Georgia", 13, [System.Drawing.FontStyle]::Bold)
$fST_Desc    = New-Object System.Drawing.Font("Georgia", 10.5, [System.Drawing.FontStyle]::Italic)
$fST_Small   = New-Object System.Drawing.Font("Segoe UI", 11.5, [System.Drawing.FontStyle]::Regular)
$fST_Combo   = New-Object System.Drawing.Font("Georgia", 14, [System.Drawing.FontStyle]::Bold)

$bGold24  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 251, 191, 36))
$bGoldSft = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 245, 158, 11))
$bCream   = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 254, 243, 199))
$bIvory   = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 252, 248, 240))
$bTaupe   = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 180, 168, 150))
$dotST    = [System.Drawing.Color]::FromArgb(255, 80, 65, 45)

# HEADER
DrawCenter $g "â€” ROYAL FINE DINING â€”" $fST_Royal $bGold24 ($W/2) 52
DrawCenter $g "SANG TRá»ŒNG HOĂ€NG GIA" $fST_Title $bGold24 ($W/2) 84
DrawCenter $g "Thá»±c ÄÆ¡n Äá»“ Uá»‘ng Cao Cáº¥ va ocktail Tinh Táº¿" $fST_Sub $bCream ($W/2) 128

# ÄÆ°á»ng vĂ ng divider + crown symbol
$penDivST = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 251, 191, 36), 1.5)
$g.DrawLine($penDivST, 120, 152, $W-120, 152)
$penDivST.Dispose()
# Kim cÆ°Æ¡ng vĂ ng giá»¯a
$ptsDiamond = @(
    New-Object System.Drawing.PointF([float]($W/2), 143.0),
    New-Object System.Drawing.PointF([float]($W/2 + 9), 152.0),
    New-Object System.Drawing.PointF([float]($W/2), 161.0),
    New-Object System.Drawing.PointF([float]($W/2 - 9), 152.0)
)
$g.FillPolygon($bGold24, $ptsDiamond)

# DANH Má»¤C 1: Äá»’ Uá»NG KHAI Vá»
$g.DrawString("I.  Äá»’ Uá»NG KHAI Vá» va IGNATURE COCKTAIL", $fST_Cat, $bGold24, [float]62, [float]172)
$penCatST = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 251, 191, 36), 1.0)
$g.DrawLine($penCatST, 62, 192, $W-62, 192)
$penCatST.Dispose()

$cocktailMenu = @(
    @("Champagne RosĂ© PhĂ¡p Nháº­p Kháº©u",   "185.000Ä‘", "Dom PĂ©rignon vintage, hÆ°Æ¡ng dĂ¢u tĂ¢ va Ă¡nh brioche"),
    @("Old Fashioned Whisky Bourbon",     "155.000Ä‘", "Bulleit Bourbon, Ä‘Æ°á»ng nĂ¢u caramel, Angostura bitters"),
    @("Negroni Cá»• Äiá»ƒn Florence",         "148.000Ä‘", "Campari, Gin Plymouth, Vermouth Rosso, vá» cam"),
    @("Aperol Spritz VÆ°á»n Äá»‹a Trung Háº£i", "128.000Ä‘", "Aperol, Prosecco Ă, soda, lĂ¡t cam tÆ°Æ¡i thÆ¡m ngĂ¡t"),
    @("Mocktail Hoa Váº£i Lychee Royal",    "95.000Ä‘",  "NÆ°á»›c Ă©p váº£i thiá»u, siro hoa há»“ng, toni va Ă¡nh hoa")
)
$ry3 = 206
foreach ($it in $cocktailMenu) {
    $g.FillEllipse($bGold24, [float]62, [float]($ry3 - 7), 5.0, 5.0)
    DrawRow $g $it[0] $it[1] $it[2] 62 $ry3 ($W-124) $fST_Item $fST_Item $fST_Desc $bIvory $bGoldSft $bTaupe $dotST
    $ry3 += 56
}

# DANH Má»¤C 2: CĂ€ PHĂ RANG XAY CAO Cáº¤P
$g.DrawString("II.  CĂ€ PHĂ RANG XA va RĂ€ THÆ¯á»¢NG Háº NG", $fST_Cat, $bGold24, [float]62, [float]498)
$penCatST2 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 251, 191, 36), 1.0)
$g.DrawLine($penCatST2, 62, 518, $W-62, 518)
$penCatST2.Dispose()

$coffeeLux = @(
    @("CĂ  PhĂª Jamaica Blue Mountain",    "245.000Ä‘", "Háº¡t Ä‘áº·c sáº£n Jamaica, hÆ°Æ¡ng thÆ¡m hoa quáº£ phá»©c há»£p"),
    @("Kopi Luwak Chá»“n HÆ°Æ¡ng Indonesia","350.000Ä‘", "CĂ  phĂª chá»“n thuáº§n tĂºy, vá»‹ bÆ¡ má»‹n, háº­u vá»‹ ngá»t lĂ¢u"),
    @("TrĂ  Pu-erh VĂ¢n Nam 10 NÄƒm",      "165.000Ä‘", "LĂ¡ trĂ  á»§ Ă©p bĂ¡nh 10 nÄƒm, vá»‹ Ä‘áº¥t Ä‘ai sĂ¢u tháº³m tinh táº¿"),
    @("Darjeeling First Flush áº¤n Äá»™",   "145.000Ä‘", "BĂºp trĂ  thu hoáº¡ch Ä‘áº§u vá»¥, hÆ°Æ¡ng muscat bá»“ Ä‘Ă o tinh khiáº¿t")
)
$ry4 = 532
foreach ($it in $coffeeLux) {
    $g.FillEllipse($bGoldSft, [float]62, [float]($ry4 - 7), 5.0, 5.0)
    DrawRow $g $it[0] $it[1] $it[2] 62 $ry4 ($W-124) $fST_Item $fST_Item $fST_Desc $bIvory $bGoldSft $bTaupe $dotST
    $ry4 += 56
}

# COMBO BOX HOĂ€NG GIA
$comboBgST = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 22, 16, 10))
FillRR $g $comboBgST 62 758 ($W-124) 145 10
$comboBgST.Dispose()
StrokeRR $g (New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 251, 191, 36), 1.5)) 62 758 ($W-124) 145 10

$fStComboPrice = New-Object System.Drawing.Font("Georgia", 20, [System.Drawing.FontStyle]::Bold)
DrawCenter $g "âœ¦  Bá»®A TIá»†C HOĂ€NG GIA  âœ¦" $fST_Cat $bGold24 ($W/2) 774
$g.DrawString("Tráº£i nghiá»‡m Degustation: 01 Cocktail Signature + 01 Kopi Luwak + PĂ¢tĂ© gan ngá»—ng", $fST_Combo, $bCream, [float]78, [float]806)
DrawRight $g "685.000Ä‘/cáº·p" $fStComboPrice $bGold24 [float]($W-62) 806
$g.DrawString("Bao gá»“m: rÆ°á»£u khai vá»‹, thá»±c Ä‘Æ¡n thÆ°á»Ÿng thá»©c 5 bÆ°á»›c, nháº¡c sá»‘ng piano cá»• Ä‘iá»ƒn (18:00 â€“ 21:30)", $fST_Small, $bTaupe, [float]78, [float]854)
$g.DrawString("Äáº·t bĂ n trÆ°á»›c: 1900 9999  Â·  Phá»¥c vá»¥ riĂªng tÆ°: yĂªu cáº§u trÆ°á»›c 24 giá»", $fST_Small, $bTaupe, [float]78, [float]880)

# FOOTER
$penFootST = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 251, 191, 36), 1.0)
$g.DrawLine($penFootST, 80, 930, $W-80, 930)
$penFootST.Dispose()
DrawCenter $g "SANG TRá»ŒNG HOĂ€NG GIA RESTAURANT  Â·  Táº§ng 28, Grand Tower" $fST_Sub $bCream ($W/2) 962
DrawCenter $g "Reservation: 1900 9999  Â·  Email: royaldining@smartmenu.vn" $fST_Small $bTaupe ($W/2) 992

$bmp.Save("$base\SANG_TRONG\sample_1.png", [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host "   OK: SANG_TRONG/sample_1.png ($W x $H)"
$g.Dispose(); $bmp.Dispose()
$bGold24.Dispose(); $bGoldSft.Dispose(); $bCream.Dispose(); $bIvory.Dispose(); $bTaupe.Dispose()


# ======================================================================
# 3. TRE_TRUNG/sample_1.png - Tráº» Trung: Bubble Te va essert Menu
#    Ná»n pastel há»“ng nháº¡t, bo trĂ²n, mĂ u tÆ°Æ¡i vui, chá»¯ Ä‘áº­m dá»… thÆ°Æ¡ng
# ======================================================================
Write-Host "==> Táº¡o TRE_TRUNG/sample_1.png..."
$W = 900; $H = 1150
$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = [System.Drawing.Graphics]::FromImage($bmp)
SetupG $g

# Ná»n pastel gradient há»“ng pháº¥n
$rect5 = New-Object System.Drawing.Rectangle(0, 0, $W, $H)
$grad5 = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect5,
    [System.Drawing.Color]::FromArgb(255, 255, 240, 246),
    [System.Drawing.Color]::FromArgb(255, 253, 232, 241),
    [System.Drawing.Drawing2D.LinearGradientMode]::Vertical)
$g.FillRectangle($grad5, 0, 0, $W, $H)
$grad5.Dispose()

# VĂ²ng trĂ²n trang trĂ­ gĂ³c (pastel decorations)
$bCircleA = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(40, 219, 39, 119))
$g.FillEllipse($bCircleA, -80.0, -80.0, 250.0, 250.0)
$g.FillEllipse($bCircleA, [float]($W-150), [float]($H-150), 220.0, 220.0)
$bCircleA.Dispose()
$bCircleB = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30, 251, 191, 36))
$g.FillEllipse($bCircleB, [float]($W-120), -60.0, 200.0, 200.0)
$g.FillEllipse($bCircleB, -60.0, [float]($H-130), 180.0, 180.0)
$bCircleB.Dispose()

# Khung bo trĂ²n rose Ä‘áº­m
$penRose = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 219, 39, 119), 2.5)
StrokeRR $g $penRose 28 28 ($W-56) ($H-56) 24
$penRose.Dispose()
$penRoseSoft = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(100, 219, 39, 119), 1.0)
StrokeRR $g $penRoseSoft 38 38 ($W-76) ($H-76) 18
$penRoseSoft.Dispose()

# Font va rushes TRE_TRUNG
$fTT_Emoji  = New-Object System.Drawing.Font("Segoe UI Emoji", 14, [System.Drawing.FontStyle]::Regular)
$fTT_Title  = New-Object System.Drawing.Font("Segoe UI", 28, [System.Drawing.FontStyle]::Bold)
$fTT_Sub    = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Regular)
$fTT_Cat    = New-Object System.Drawing.Font("Segoe UI", 15, [System.Drawing.FontStyle]::Bold)
$fTT_Item   = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
$fTT_Desc   = New-Object System.Drawing.Font("Segoe UI", 10.5, [System.Drawing.FontStyle]::Italic)
$fTT_Small  = New-Object System.Drawing.Font("Segoe UI", 11.5, [System.Drawing.FontStyle]::Regular)
$fTT_Combo  = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$fTT_Price  = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)

$bRose   = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 219, 39, 119))
$bDRose  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 157, 23, 77))
$bPurple = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 168, 85, 247))
$bOrangeT= New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 234, 88, 12))
$bDark55 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 50, 35, 45))
$bGray55 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 140, 120, 132))
$bPinkBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 228, 238))
$dotTT   = [System.Drawing.Color]::FromArgb(255, 251, 182, 218)

# HEADER â€“ pill lá»›n Ä‘Ă¡nh dáº¥u tĂªn quĂ¡n
$headerBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 219, 39, 119))
FillRR $g $headerBg 60 46 ($W-120) 58 29
$headerBg.Dispose()
$bWhiteTT = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
DrawCenter $g "âœ¨ CUTE BOB va ESSERT BAR âœ¨" $fTT_Title $bWhiteTT ($W/2) 60
$bWhiteTT.Dispose()

DrawCenter $g "Thá»±c ÄÆ¡n TrĂ  Sá»¯a TrĂ¢n ChĂ¢ va á»“ Ngá»t TÆ°Æ¡i MĂ¡t" $fTT_Sub $bDRose ($W/2) 118
DrawCenter $g "TĂ¹y chá»‰nh: ÄÆ°á»ng 0 â€“ 100%  Â·  ÄĂ¡ Ă­t / vá»«a / nhiá»u  Â·  Size S / M / L" $fTT_Sub $bGray55 ($W/2) 142

# Divider dĂ¢y hoa
$penDivTT = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 251, 182, 218), 2.0)
$g.DrawLine($penDivTT, 80, 166, $W-80, 166)
$penDivTT.Dispose()
$g.FillEllipse($bRose, [float]($W/2-5), 160.0, 10.0, 10.0)

# DANH Má»¤C 1: TRĂ€ Sá»®A TRĂ‚N CHĂ‚U
$sec3Bg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 240, 246))
FillRR $g $sec3Bg 50 178 ($W-100) 300 16
$sec3Bg.Dispose()
StrokeRR $g (New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 219, 39, 119), 1.5)) 50 178 ($W-100) 300 16

# Pill tiĂªu Ä‘á» danh má»¥c
$catPill = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 219, 39, 119))
FillRR $g $catPill 70 166 252 28 14
$catPill.Dispose()
$bWh2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$g.DrawString("đŸ§‹ TRĂ€ Sá»®A TRĂ‚N CHĂ‚U", $fTT_Cat, $bWh2, [float]84, [float]176)
$bWh2.Dispose()

$bubbleTea = @(
    @("TrĂ  Sá»¯a Khoai MĂ´n Hoa ÄĂ o",   "49.000Ä‘", "Khoai mĂ´n ÄĂ  Láº¡t tĂ­m bĂ©o ngáº­y, trĂ¢n chĂ¢u Ä‘en bĂ¹i má»m"),
    @("Matcha Red Bean Latte",        "52.000Ä‘", "TrĂ  xanh Uji pha sá»¯a tÆ°Æ¡i, Ä‘áº­u Ä‘á» háº§m ngá»t bĂ¹i"),
    @("TrĂ  Sá»¯a DÆ°a Gang VĂ ng",       "48.000Ä‘", "DÆ°a gang ngá»t thÆ¡m, sá»¯a tÆ°Æ¡i mĂ¡t láº¡nh, tháº¡ch cáº§u vá»“ng"),
    @("Brown Sugar Boba TrĂ¢n ChĂ¢u",   "52.000Ä‘", "ÄÆ°á»ng nĂ¢u caramel cháº£y, trĂ¢n chĂ¢u nÆ°á»›ng dáº»o, sá»¯a tÆ°Æ¡i"),
    @("Taro Coconut Jelly Crush",     "55.000Ä‘", "Cá»‘t dá»«a bĂ©o quyá»‡n khoai mĂ´n, tháº¡ch nha Ä‘am giĂ²n mĂ¡t")
)
$ry5 = 204
foreach ($it in $bubbleTea) {
    $g.FillEllipse($bRose, [float]70, [float]($ry5 - 7), 6.0, 6.0)
    DrawRow $g $it[0] $it[1] $it[2] 70 $ry5 ($W-140) $fTT_Item $fTT_Item $fTT_Desc $bDark55 $bOrangeT $bGray55 $dotTT
    $ry5 += 55
}

# DANH Má»¤C 2: NÆ¯á»C TRĂI CĂ‚ va Ă XAY
$sec4Bg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 240, 246))
FillRR $g $sec4Bg 50 492 ($W-100) 300 16
$sec4Bg.Dispose()
StrokeRR $g (New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 168, 85, 247), 1.5)) 50 492 ($W-100) 300 16

$catPill2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 168, 85, 247))
FillRR $g $catPill2 70 480 274 28 14
$catPill2.Dispose()
$bWh3 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$g.DrawString("đŸ“ ÄĂ XA va Æ¯á»C TRĂI CĂ‚Y", $fTT_Cat, $bWh3, [float]84, [float]490)
$bWh3.Dispose()

$fruitBar = @(
    @("ÄĂ¡ Xay DĂ¢u TĂ¢y Kem TÆ°Æ¡i",     "55.000Ä‘", "DĂ¢u tĂ¢y ÄĂ  Láº¡t tÆ°Æ¡i xay má»‹n, kem tÆ°Æ¡i whip ngá»t bĂ¹i"),
    @("Sinh Tá»‘ XoĂ i Dá»«a TrĂ´i Ná»•i",   "50.000Ä‘", "XoĂ i cĂ¡t HĂ²a Lá»™c chĂ­n ngá»t, nÆ°á»›c dá»«a tÆ°Æ¡i mĂ¡t lĂ nh"),
    @("ÄĂ¡ Xay PhĂºc Bá»“n Tá»­ Yogurt",   "55.000Ä‘", "Raspberry tÆ°Æ¡i, sá»¯a chua Hy Láº¡p sĂ¡nh má»‹n, granola giĂ²n"),
    @("Soda Chanh Muá»‘i Viá»‡t Nam",     "38.000Ä‘", "Chanh tÆ°Æ¡i nguyĂªn cháº¥t, muá»‘i há»“ng Himalaya, soda sá»§i bá»t"),
    @("Lemonade Hoa Oáº£i HÆ°Æ¡ng",       "45.000Ä‘", "Chanh vĂ ng tÆ°Æ¡i, siro lavender, sod va int tÆ°Æ¡i mĂ¡t")
)
$ry6 = 518
foreach ($it in $fruitBar) {
    $g.FillEllipse($bPurple, [float]70, [float]($ry6 - 7), 6.0, 6.0)
    DrawRow $g $it[0] $it[1] $it[2] 70 $ry6 ($W-140) $fTT_Item $fTT_Item $fTT_Desc $bDark55 $bOrangeT $bGray55 $dotTT
    $ry6 += 55
}

# COMBO CUTE
$comboBgTT = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 253, 232, 241))
FillRR $g $comboBgTT 50 808 ($W-100) 148 16
$comboBgTT.Dispose()
StrokeRR $g (New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 219, 39, 119), 2.0)) 50 808 ($W-100) 148 16

$badgeTT = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 234, 88, 12))
FillRR $g $badgeTT 70 795 220 28 14
$badgeTT.Dispose()
$bWh4 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$fBadgeTT = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$g.DrawString("đŸ€ BESTIE COMBO", $fBadgeTT, $bWh4, [float]84, [float]805)
$fBadgeTT.Dispose(); $bWh4.Dispose()

$g.DrawString("Combo Bestie: 02 TrĂ  Sá»¯a Báº¥t Ká»³ + 02 BĂ¡nh Mochi Matcha/DĂ¢u", $fTT_Combo, $bDRose, [float]70, [float]832)
DrawRight $g "89.000Ä‘" $fTT_Price $bOrangeT [float]($W-60) 832
$g.DrawString("Chá»¥p áº£nh check-in quĂ¡ va ag @CuteBoba â†’ Giáº£m ngay 10% hĂ³a Ä‘Æ¡n tiáº¿p theo!", $fTT_Small, $bGray55, [float]70, [float]874)
$g.DrawString("Topping miá»…n phĂ­: TrĂ¢n chĂ¢u / Tháº¡ch cáº§u vá»“ng / Pudding trá»©ng (chá»n 1)", $fTT_Small, $bGray55, [float]70, [float]898)
$g.DrawString("Topping thĂªm: Kem cheese (+12k) Â· Pudding thĂªm (+8k) Â· Tháº¡ch nha Ä‘am (+8k)", $fTT_Small, $bGray55, [float]70, [float]924)

# FOOTER
$penFootTT = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 219, 39, 119), 1.5)
$g.DrawLine($penFootTT, 80, 976, $W-80, 976)
$penFootTT.Dispose()
DrawCenter $g "CUTE BOBA BAR  âœ¨  Má»Ÿ cá»­a 09:00 â€“ 23:00 má»—i ngĂ y" $fTT_Sub $bDRose ($W/2) 1004
DrawCenter $g "Hotline: 1900 2468  Â·  Instagram: @CuteBoba  Â·  Wifi: BoBa_Free" $fTT_Small $bGray55 ($W/2) 1030

$bmp.Save("$base\TRE_TRUNG\sample_1.png", [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host "   OK: TRE_TRUNG/sample_1.png ($W x $H)"
$g.Dispose(); $bmp.Dispose()
$bRose.Dispose(); $bDRose.Dispose(); $bPurple.Dispose(); $bOrangeT.Dispose()
$bDark55.Dispose(); $bGray55.Dispose(); $bPinkBg.Dispose()


# ======================================================================
# 4. TRUYEN_THONG/sample_1.png - Truyá»n Thá»‘ng: QuĂ¡n CĂ  PhĂª SĂ¢n VÆ°á»n Viá»‡t
#    Ná»n giáº¥y parchment vĂ ng áº¥m, chá»¯ nĂ¢u sepia, viá»n cá»• Ä‘iá»ƒn retro
# ======================================================================
Write-Host "==> Táº¡o TRUYEN_THONG/sample_1.png..."
$W = 800; $H = 1100
$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = [System.Drawing.Graphics]::FromImage($bmp)
SetupG $g

# Ná»n parchment áº¥m Ă¡p
$rect7 = New-Object System.Drawing.Rectangle(0, 0, $W, $H)
$grad7 = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect7,
    [System.Drawing.Color]::FromArgb(255, 253, 244, 220),
    [System.Drawing.Color]::FromArgb(255, 247, 234, 200),
    [System.Drawing.Drawing2D.LinearGradientMode]::Vertical)
$g.FillRectangle($grad7, 0, 0, $W, $H)
$grad7.Dispose()

# Viá»n retro nĂ¢u Ä‘Ă´i
$penBr1 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 120, 53, 15), 4.0)
$g.DrawRectangle($penBr1, 20, 20, $W-40, $H-40)
$penBr1.Dispose()
$penBr2 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 120, 53, 15), 1.5)
$g.DrawRectangle($penBr2, 32, 32, $W-64, $H-64)
$penBr2.Dispose()

# Há»a tiáº¿t gĂ³c retro
$penCornerBr = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 120, 53, 15), 2.0)
$csR = 28
# TL
$g.DrawLine($penCornerBr, 42, 42, 42+$csR, 42); $g.DrawLine($penCornerBr, 42, 42, 42, 42+$csR)
$g.DrawLine($penCornerBr, 42+8, 42+8, 42+$csR-4, 42+8)
# TR
$g.DrawLine($penCornerBr, $W-42-$csR, 42, $W-42, 42); $g.DrawLine($penCornerBr, $W-42, 42, $W-42, 42+$csR)
$g.DrawLine($penCornerBr, $W-42-$csR+4, 42+8, $W-42-8, 42+8)
# BL
$g.DrawLine($penCornerBr, 42, $H-42-$csR, 42, $H-42); $g.DrawLine($penCornerBr, 42, $H-42, 42+$csR, $H-42)
$g.DrawLine($penCornerBr, 42+8, $H-42-8, 42+8, $H-42-$csR+4)
# BR
$g.DrawLine($penCornerBr, $W-42-$csR, $H-42, $W-42, $H-42); $g.DrawLine($penCornerBr, $W-42, $H-42-$csR, $W-42, $H-42)
$g.DrawLine($penCornerBr, $W-42-$csR+4, $H-42-8, $W-42-8, $H-42-8)
$penCornerBr.Dispose()

# Font va rushes TRUYEN_THONG
$fTR_Tag   = New-Object System.Drawing.Font("Georgia", 11, [System.Drawing.FontStyle]::Italic)
$fTR_Title = New-Object System.Drawing.Font("Georgia", 28, [System.Drawing.FontStyle]::Bold)
$fTR_Sub   = New-Object System.Drawing.Font("Georgia", 13, [System.Drawing.FontStyle]::Italic)
$fTR_Cat   = New-Object System.Drawing.Font("Georgia", 14, [System.Drawing.FontStyle]::Bold)
$fTR_Item  = New-Object System.Drawing.Font("Georgia", 13, [System.Drawing.FontStyle]::Bold)
$fTR_Desc  = New-Object System.Drawing.Font("Georgia", 10, [System.Drawing.FontStyle]::Italic)
$fTR_Small = New-Object System.Drawing.Font("Georgia", 11, [System.Drawing.FontStyle]::Regular)
$fTR_Combo = New-Object System.Drawing.Font("Georgia", 13, [System.Drawing.FontStyle]::Bold)

$bSepia  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 120, 53, 15))
$bBrown  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 68, 26, 8))
$bAmberTR= New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 180, 83, 9))
$bWarmTR = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 150, 130, 100))
$dotTR   = [System.Drawing.Color]::FromArgb(255, 200, 170, 120)

# HEADER
DrawCenter $g "â€” QuĂ¡n CĂ  PhĂª SĂ¢n VÆ°á»n â€”" $fTR_Tag $bSepia ($W/2) 48
DrawCenter $g "TRUYá»€N THá»NG Cá»” ÄIá»‚N" $fTR_Title $bBrown ($W/2) 80
DrawCenter $g "HÆ°Æ¡ng Vá»‹ Thuáº§n Viá»‡t â€” NÆ¡i LÆ°u Giá»¯ KĂ½ á»¨c" $fTR_Sub $bSepia ($W/2) 122

# ÄÆ°á»ng káº» nĂ¢u sepia + ornament
$penDivTR = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 150, 100, 50), 1.5)
$g.DrawLine($penDivTR, 80, 148, $W-80, 148)
$penDivTR.Dispose()
# Háº¡t cĂ  phĂª kĂ½ hiá»‡u
DrawCenter $g "â€” â˜• â€”" $fTR_Tag $bSepia ($W/2) 156

# DANH Má»¤C 1: CĂ€ PHĂ TRUYá»€N THá»NG VIá»†T
$g.DrawString("CĂ€ PHĂ TRUYá»€N THá»NG VIá»†T NAM", $fTR_Cat, $bBrown, [float]52, [float]182)
$penCatTR = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 120, 53, 15), 1.5)
$g.DrawLine($penCatTR, 52, 202, $W-52, 202)
$penCatTR.Dispose()

$trvnMenu = @(
    @("CĂ  PhĂª Sá»¯a ÄĂ¡ Kem Phin",     "35.000Ä‘", "Pha phin nhá» giá»t cháº­m, Ä‘Ă¡ viĂªn to, sá»¯a Ä‘áº·c Ă´ng Thá»"),
    @("CĂ  PhĂª Äen ÄĂ¡ Äáº­m Vá»‹",       "28.000Ä‘", "Robusta BuĂ´n Ma Thuá»™t rang Ä‘áº­m, háº­u vá»‹ Ä‘áº¯ng hoa quáº£"),
    @("Báº¡c Xá»‰u Sá»¯a Kem TÆ°Æ¡i",       "38.000Ä‘", "CĂ  phĂª phin loĂ£ng, sá»¯a tÆ°Æ¡i áº¥m, kem tÆ°Æ¡i phá»§ máº·t"),
    @("CĂ  PhĂª Trá»©ng HĂ  Ná»™i",        "42.000Ä‘", "CĂ´ng thá»©c truyá»n thá»‘ng HĂ ng Gai, kem trá»©ng Ä‘Ă¡nh bĂ´ng"),
    @("CĂ  PhĂª Dá»«a Äáº·c Sáº£n Há»™i An",  "45.000Ä‘", "Äáº·c sáº£n phá»‘ Há»™i, cá»‘t dá»«a Báº¿n Tre bĂ©o sĂ¡nh, Ä‘Ă¡ xay má»‹n"),
    @("CĂ  PhĂª Chá»“n Cáº©m Tháº¡ch",      "95.000Ä‘", "Háº¡t cĂ  phĂª chá»“n thuáº§n chá»§ng, vá»‹ bÆ¡ ngá»t háº­u vá»‹ thanh")
)
$ry7 = 216
foreach ($it in $trvnMenu) {
    $bDotTR = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 120, 53, 15))
    $g.FillEllipse($bDotTR, [float]52, [float]($ry7 - 7), 5.0, 5.0)
    $bDotTR.Dispose()
    DrawRow $g $it[0] $it[1] $it[2] 52 $ry7 ($W-104) $fTR_Item $fTR_Item $fTR_Desc $bBrown $bAmberTR $bWarmTR $dotTR
    $ry7 += 52
}

# DANH Má»¤C 2: TRĂ€ Há» va Æ¯á»C GIáº¢I KHĂT
$g.DrawString("TRĂ€ Há» va Æ¯á»C GIáº¢I KHĂT TRUYá»€N THá»NG", $fTR_Cat, $bBrown, [float]52, [float]540)
$penCatTR2 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 120, 53, 15), 1.5)
$g.DrawLine($penCatTR2, 52, 560, $W-52, 560)
$penCatTR2.Dispose()

$traViet = @(
    @("TrĂ  ÄĂ¡ Miá»n Nam Thuáº§n TĂºy",   "18.000Ä‘", "TrĂ  Ă” long tĂºc máº¡nh pha nÆ°á»›c sĂ´i, Ä‘Ă¡ cá»¥c to mĂ¡t láº¡nh"),
    @("TrĂ  Sen Há»“ TĂ¢y ThÆ°á»£ng Háº¡ng",  "55.000Ä‘", "TrĂ  xanh Æ°á»›p sen bĂ¡ch diá»‡p Há»“ TĂ¢y, hÆ°Æ¡ng hoa thanh khiáº¿t"),
    @("NÆ°á»›c Chanh Máº­t Ong Gá»«ng",     "32.000Ä‘", "Chanh tÆ°Æ¡i váº¯t, máº­t ong nguyĂªn cháº¥t, gá»«ng cay áº¥m bá»¥ng"),
    @("NÆ°á»›c MĂ­a Sáº£ Chanh TÆ°Æ¡i",      "25.000Ä‘", "MĂ­a Háº­u Giang Ă©p tÆ°Æ¡i, sáº£ Ä‘áº­p dáº­p, chanh tÆ°Æ¡ va ‘Ă¡ viĂªn"),
    @("SĂ¢m Bá»• LÆ°á»£ng Ngá»c Trai",      "38.000Ä‘", "Bá»™t bĂ¡ng, háº¡t sen, tĂ¡o Ä‘á», long nhĂ£n, Ä‘Æ°á»ng phĂ¨n mĂ¡t")
)
$ry8 = 574
foreach ($it in $traViet) {
    $bDotTR2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 180, 83, 9))
    $g.FillEllipse($bDotTR2, [float]52, [float]($ry8 - 7), 5.0, 5.0)
    $bDotTR2.Dispose()
    DrawRow $g $it[0] $it[1] $it[2] 52 $ry8 ($W-104) $fTR_Item $fTR_Item $fTR_Desc $bBrown $bAmberTR $bWarmTR $dotTR
    $ry8 += 50
}

# COMBO CĂ€ PHĂ SĂNG Sá»M
$comboBgTR = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 244, 228, 188))
FillRR $g $comboBgTR 52 828 ($W-104) 138 8
$comboBgTR.Dispose()
StrokeRR $g (New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 120, 53, 15), 1.5)) 52 828 ($W-104) 138 8

DrawCenter $g "â€” Combo SĂ¡ng Sá»›m Äáº·c Biá»‡t â€”" $fTR_Cat $bBrown ($W/2) 848
$g.DrawString("01 CĂ  PhĂª Sá»¯a ÄĂ¡ + 01 BĂ¡nh MĂ¬ Pat va rá»©ng á»p La GiĂ²n", $fTR_Combo, $bBrown, [float]68, [float]876)
DrawRight $g "55.000Ä‘" (New-Object System.Drawing.Font("Georgia", 18, [System.Drawing.FontStyle]::Bold)) $bAmberTR [float]($W-56) 876
$g.DrawString("Phá»¥c vá»¥ 06:30 â€“ 10:30  Â·  Ä‚n táº¡i quĂ¡n  Â·  Tiáº¿t kiá»‡m 12.000Ä‘", $fTR_Small, $bWarmTR, [float]68, [float]912)
$g.DrawString("ThĂªm: BĂ¡nh croissant (+15k) Â· ThĂªm trá»©ng (+8k) Â· NÆ°á»›c cam váº¯t thĂªm (+12k)", $fTR_Small, $bWarmTR, [float]68, [float]938)

# FOOTER
$penFootTR = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 120, 53, 15), 1.5)
$g.DrawLine($penFootTR, 80, 988, $W-80, 988)
$penFootTR.Dispose()
DrawCenter $g "CĂ€ PHĂ TRUYá»€N THá»NG â€” NÆ¡i Káº¿t Ná»‘i Tháº¿ Há»‡" $fTR_Sub $bSepia ($W/2) 1018
DrawCenter $g "Má»Ÿ cá»­a 06:30 â€“ 21:30  Â·  Vá»‰a hĂ¨ sĂ¢n vÆ°á»n  Â·  Hotline: 1900 5555" $fTR_Small $bWarmTR ($W/2) 1048

$bmp.Save("$base\TRUYEN_THONG\sample_1.png", [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host "   OK: TRUYEN_THONG/sample_1.png ($W x $H)"
$g.Dispose(); $bmp.Dispose()
$bSepia.Dispose(); $bBrown.Dispose(); $bAmberTR.Dispose(); $bWarmTR.Dispose()

Write-Host ""
Write-Host "===== HOĂ€N Táº¤T ====="
Write-Host "ÄĂ£ táº¡o sample_1.png trong 4 thÆ° má»¥c style:"
Write-Host "  HIEN_DAI/sample_1.png    â€” Specialty Coffe va spresso Menu (navy tá»‘i)"
Write-Host "  SANG_TRONG/sample_1.png  â€” Fine Dining Cocktai va uxury Coffee (Ä‘en vĂ ng)"
Write-Host "  TRE_TRUNG/sample_1.png   â€” Bubble Te va essert Bar (pastel há»“ng)"
Write-Host "  TRUYEN_THONG/sample_1.png â€” QuĂ¡n CĂ  PhĂª SĂ¢n VÆ°á»n Viá»‡t (giáº¥y nĂ¢u cá»•)"

