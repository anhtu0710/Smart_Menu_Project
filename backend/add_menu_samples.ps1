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
    $p.CloseFigure(); $g.FillPath($brush, $p); $p.Dispose()
}

function StrokeRR($g, $pen, $x, $y, $w, $h, $r) {
    $p = New-Object System.Drawing.Drawing2D.GraphicsPath
    $p.AddArc([float]$x, [float]$y, [float]($r*2), [float]($r*2), 180, 90)
    $p.AddArc([float]($x+$w-$r*2), [float]$y, [float]($r*2), [float]($r*2), 270, 90)
    $p.AddArc([float]($x+$w-$r*2), [float]($y+$h-$r*2), [float]($r*2), [float]($r*2), 0, 90)
    $p.AddArc([float]$x, [float]($y+$h-$r*2), [float]($r*2), [float]($r*2), 90, 90)
    $p.CloseFigure(); $g.DrawPath($pen, $p); $p.Dispose()
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

# ======================================================================
# 1. HIEN_DAI/sample_1.png — Modern Espresso Bar (navy toi, cyan, vang)
# ======================================================================
Write-Host "==> Tao HIEN_DAI/sample_1.png..."
$W = 800; $H = 1100
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

# Thanh cyan tren duoi
$cBar = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 56, 189, 248))
$g.FillRectangle($cBar, 0, 0, $W, 6)
$g.FillRectangle($cBar, 0, [float]($H-6), $W, 6)
$cBar.Dispose()

# Vien cyan ben trong
$penCyan = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(55, 56, 189, 248), 1.0)
$g.DrawRectangle($penCyan, 22, 22, $W-44, $H-44)
$penCyan.Dispose()

# Fonts
$fLogo  = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$fTitle = New-Object System.Drawing.Font("Segoe UI", 28, [System.Drawing.FontStyle]::Bold)
$fSub   = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Regular)
$fCat   = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
$fItem  = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
$fDesc  = New-Object System.Drawing.Font("Segoe UI", 10.5, [System.Drawing.FontStyle]::Italic)
$fSmall = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Regular)
$fCPr   = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$fCNm   = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)

# Brushes
$bCyan  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 56, 189, 248))
$bWhite = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 248, 250, 252))
$bAmber = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 245, 158, 11))
$bGray  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 148, 163, 184))
$bSlate = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 100, 116, 139))
$bDkNav = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 10, 20, 42))
$dotHD  = [System.Drawing.Color]::FromArgb(255, 25, 55, 90)

DrawCenter $g "SPECIALTY COFFEE MENU" $fLogo $bCyan ($W/2) 38
DrawCenter $g "THE MODERN ESPRESSO BAR" $fTitle $bWhite ($W/2) 66
DrawCenter $g "Thuong Thuc Ca Phe Dac San — Premium Coffee Experience" $fSub $bGray ($W/2) 106

$penDiv = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 56, 189, 248), 2.0)
$g.DrawLine($penDiv, 60, 128, $W-60, 128)
$penDiv.Dispose()
$g.FillEllipse($bCyan, [float]($W/2-4), 123.0, 9.0, 9.0)

# --- DANH MUC 1: CA PHE ESPRESSO ---
$bg1 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 14, 22, 42))
FillRR $g $bg1 40 148 ($W-80) 278 8
$bg1.Dispose()
StrokeRR $g (New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(100, 56, 189, 248), 1.0)) 40 148 ($W-80) 278 8

$penCL1 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 56, 189, 248), 2.5)
$g.DrawLine($penCL1, 60, 174, 78, 174)
$penCL1.Dispose()
$g.DrawString("CA PHE ESPRESSO VA POUR OVER", $fCat, $bCyan, [float]84, [float]162)

$menu1 = @(
    @("Espresso Don Nguyen Ban",       "35.000d", "Single origin Ethiopia Yirgacheffe, hau vi cam quyt tinh te"),
    @("Flat White Sua Macadamia",      "55.000d", "Ristretto double shot, sua Macadamia rang thom bui"),
    @("Pour Over Don Nguon Goc",       "65.000d", "V60 hand drip, hat Arabica Cau Dat, huong moc thanh"),
    @("Cortado Tay Ban Nha",           "48.000d", "Espresso va steamed milk ty le 1-1, dam da thanh tao"),
    @("Cold Brew Nitro Bong Bong",     "58.000d", "Cold brew u 20h, nitrogen infused, bot kem min muot")
)
$ry = 193
foreach ($it in $menu1) {
    $g.FillEllipse($bCyan, [float]60, [float]($ry-7), 5.0, 5.0)
    DrawRow $g $it[0] $it[1] $it[2] 60 $ry ($W-120) $fItem $fItem $fDesc $bWhite $bAmber $bSlate $dotHD
    $ry += 50
}

# --- DANH MUC 2: DA XAY VA LATTE ---
$bg2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 14, 22, 42))
FillRR $g $bg2 40 442 ($W-80) 248 8
$bg2.Dispose()
StrokeRR $g (New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(100, 245, 158, 11), 1.0)) 40 442 ($W-80) 248 8

$penCL2 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 245, 158, 11), 2.5)
$g.DrawLine($penCL2, 60, 468, 78, 468)
$penCL2.Dispose()
$g.DrawString("DA XAY SIGNATURE VA LATTE", $fCat, $bAmber, [float]84, [float]456)

$menu2 = @(
    @("Caramel Macchiato Da Xay",  "62.000d", "Vanilla latte, caramel drizzle, da xay min nhu kem"),
    @("Matcha Latte Da Xay",       "60.000d", "Bot tra Uji Nhat Ban, kem tuoi, vi dang ngot can bang"),
    @("Hazelnut Mocha Den",        "58.000d", "Espresso, chocolate den 70%, siro hat phi thom ngat"),
    @("Brown Sugar Milk Tea",      "55.000d", "Duong nau caramel, tran chau nuong, sua tuoi thanh ngot")
)
$ry2 = 488
foreach ($it in $menu2) {
    $g.FillEllipse($bAmber, [float]60, [float]($ry2-7), 5.0, 5.0)
    DrawRow $g $it[0] $it[1] $it[2] 60 $ry2 ($W-120) $fItem $fItem $fDesc $bWhite $bAmber $bSlate $dotHD
    $ry2 += 50
}

# COMBO BOX
$cmbBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 10, 18, 38))
FillRR $g $cmbBg 40 706 ($W-80) 130 8
$cmbBg.Dispose()
StrokeRR $g (New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 245, 158, 11), 1.5)) 40 706 ($W-80) 130 8

$badgeBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 245, 158, 11))
FillRR $g $badgeBg 60 694 188 26 13
$badgeBg.Dispose()
$fBdg = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$g.DrawString("DAILY COMBO DEAL", $fBdg, $bDkNav, [float]72, [float]703)
$fBdg.Dispose()

$g.DrawString("Combo Tinh Te: 01 Pour Over + 01 Banh Croissant Hanh Nhan", $fCNm, $bWhite, [float]58, [float]730)
$g.DrawString("99.000d", $fCPr, $bAmber, [float]($W-175), [float]730)
$g.DrawString("Mua 2 thuc uong bat ky giam ngay 15%  -  AP dung cac ngay trong tuan", $fSmall, $bGray, [float]58, [float]768)
$g.DrawString("Topping: Kem tuoi whip (+12k)  -  Espresso them shot (+15k)  -  Siro them vi (+8k)", $fSmall, $bGray, [float]58, [float]792)

$penFoot = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 56, 189, 248), 1.5)
$g.DrawLine($penFoot, 60, 858, $W-60, 858)
$penFoot.Dispose()
DrawCenter $g "THE MODERN ESPRESSO BAR  -  Mo cua 07:00 - 22:30" $fSub $bGray ($W/2) 882
DrawCenter $g "Hotline: 1900 6868  -  Wifi: Modern_Coffee (Pass: espresso2024)" $fSmall $bSlate ($W/2) 908

$bmp.Save("$base\HIEN_DAI\sample_1.png", [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host ("   Da luu: HIEN_DAI/sample_1.png  " + $W + "x" + $H)
$g.Dispose(); $bmp.Dispose()
$bCyan.Dispose(); $bWhite.Dispose(); $bAmber.Dispose(); $bGray.Dispose()
$bSlate.Dispose(); $bDkNav.Dispose()


# ======================================================================
# 2. SANG_TRONG/sample_1.png — Fine Dining Luxury (den espresso, vang 24K)
# ======================================================================
Write-Host "==> Tao SANG_TRONG/sample_1.png..."
$W = 900; $H = 1150
$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = [System.Drawing.Graphics]::FromImage($bmp)
SetupG $g

$rect2 = New-Object System.Drawing.Rectangle(0, 0, $W, $H)
$grad2 = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect2,
    [System.Drawing.Color]::FromArgb(255, 18, 14, 12),
    [System.Drawing.Color]::FromArgb(255, 28, 22, 18),
    [System.Drawing.Drawing2D.LinearGradientMode]::Vertical)
$g.FillRectangle($grad2, 0, 0, $W, $H)
$grad2.Dispose()

$penGO = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 251, 191, 36), 2.5)
$g.DrawRectangle($penGO, 24, 24, $W-48, $H-48)
$penGO.Dispose()
$penGI = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 251, 191, 36), 1.0)
$g.DrawRectangle($penGI, 34, 34, $W-68, $H-68)
$penGI.Dispose()

$penCrn = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 251, 191, 36), 2.0)
$cs3 = 30
$g.DrawLine($penCrn, 44, 44, 44+$cs3, 44);           $g.DrawLine($penCrn, 44, 44, 44, 44+$cs3)
$g.DrawLine($penCrn, $W-44-$cs3, 44, $W-44, 44);     $g.DrawLine($penCrn, $W-44, 44, $W-44, 44+$cs3)
$g.DrawLine($penCrn, 44, $H-44-$cs3, 44, $H-44);     $g.DrawLine($penCrn, 44, $H-44, 44+$cs3, $H-44)
$g.DrawLine($penCrn, $W-44-$cs3, $H-44, $W-44, $H-44); $g.DrawLine($penCrn, $W-44, $H-44-$cs3, $W-44, $H-44)
$penCrn.Dispose()

$fSTt  = New-Object System.Drawing.Font("Georgia", 28, [System.Drawing.FontStyle]::Bold)
$fSTi  = New-Object System.Drawing.Font("Georgia", 12, [System.Drawing.FontStyle]::Italic)
$fSTs  = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Regular)
$fSTc  = New-Object System.Drawing.Font("Georgia", 14, [System.Drawing.FontStyle]::Bold)
$fSTm  = New-Object System.Drawing.Font("Georgia", 13, [System.Drawing.FontStyle]::Bold)
$fSTd  = New-Object System.Drawing.Font("Georgia", 10.5, [System.Drawing.FontStyle]::Italic)
$fSTsl = New-Object System.Drawing.Font("Segoe UI", 11.5, [System.Drawing.FontStyle]::Regular)
$fSTcp = New-Object System.Drawing.Font("Georgia", 18, [System.Drawing.FontStyle]::Bold)
$fSTcn = New-Object System.Drawing.Font("Georgia", 14, [System.Drawing.FontStyle]::Bold)

$bG24  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 251, 191, 36))
$bGSft = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 245, 158, 11))
$bCrm  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 254, 243, 199))
$bIvy  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 252, 248, 240))
$bTau  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 180, 168, 150))
$dotST = [System.Drawing.Color]::FromArgb(255, 80, 65, 45)

DrawCenter $g "— ROYAL FINE DINING —" $fSTi $bG24 ($W/2) 52
DrawCenter $g "SANG TRONG HOANG GIA" $fSTt $bG24 ($W/2) 84
DrawCenter $g "Thuc Don Do Uong Cao Cap va Cocktail Tinh Te" $fSTs $bCrm ($W/2) 128

$penDivST = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 251, 191, 36), 1.5)
$g.DrawLine($penDivST, 120, 152, $W-120, 152)
$penDivST.Dispose()
$ptsDmnd = @(
    New-Object System.Drawing.PointF([float]($W/2), 143.0),
    New-Object System.Drawing.PointF([float]($W/2+9), 152.0),
    New-Object System.Drawing.PointF([float]($W/2), 161.0),
    New-Object System.Drawing.PointF([float]($W/2-9), 152.0)
)
$g.FillPolygon($bG24, $ptsDmnd)

# CAT 1
$g.DrawString("I.  DO UONG KHAI VI VA SIGNATURE COCKTAIL", $fSTc, $bG24, [float]62, [float]172)
$penSTC1 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 251, 191, 36), 1.0)
$g.DrawLine($penSTC1, 62, 192, $W-62, 192)
$penSTC1.Dispose()

$menu3 = @(
    @("Champagne Rose Phap Nhap Khau",      "185.000d", "Dom Perignon vintage, huong dau tay va banh brioche"),
    @("Old Fashioned Whisky Bourbon",        "155.000d", "Bulleit Bourbon, duong nau caramel, Angostura bitters"),
    @("Negroni Co Dien Florence",            "148.000d", "Campari, Gin Plymouth, Vermouth Rosso, vo cam"),
    @("Aperol Spritz Vuon Dia Trung Hai",    "128.000d", "Aperol, Prosecco Y, soda, lat cam tuoi thom ngat"),
    @("Mocktail Hoa Vai Lychee Royal",       "95.000d",  "Nuoc ep vai thieu, siro hoa hong, tonic va canh hoa")
)
$ry3 = 206
foreach ($it in $menu3) {
    $g.FillEllipse($bG24, [float]62, [float]($ry3-7), 5.0, 5.0)
    DrawRow $g $it[0] $it[1] $it[2] 62 $ry3 ($W-124) $fSTm $fSTm $fSTd $bIvy $bGSft $bTau $dotST
    $ry3 += 56
}

# CAT 2
$g.DrawString("II.  CA PHE RANG XAY VA TRA THUONG HANG", $fSTc, $bG24, [float]62, [float]498)
$penSTC2 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 251, 191, 36), 1.0)
$g.DrawLine($penSTC2, 62, 518, $W-62, 518)
$penSTC2.Dispose()

$menu4 = @(
    @("Ca Phe Jamaica Blue Mountain",    "245.000d", "Hat dac san Jamaica, huong thom hoa qua phuc hop"),
    @("Kopi Luwak Chon Huong Indonesia", "350.000d", "Ca phe chon thuan tuy, vi bo min, hau vi ngot lau"),
    @("Tra Pu-erh Van Nam 10 Nam",       "165.000d", "La tra u ep banh 10 nam, vi dat dai sau tham tinh te"),
    @("Darjeeling First Flush An Do",    "145.000d", "Bup tra thu hoach dau vu, huong muscat tinh khiet")
)
$ry4 = 532
foreach ($it in $menu4) {
    $g.FillEllipse($bGSft, [float]62, [float]($ry4-7), 5.0, 5.0)
    DrawRow $g $it[0] $it[1] $it[2] 62 $ry4 ($W-124) $fSTm $fSTm $fSTd $bIvy $bGSft $bTau $dotST
    $ry4 += 56
}

# COMBO HOANG GIA
$cmbST = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 22, 16, 10))
FillRR $g $cmbST 62 760 ($W-124) 140 10
$cmbST.Dispose()
StrokeRR $g (New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 251, 191, 36), 1.5)) 62 760 ($W-124) 140 10

DrawCenter $g "-- BUA TIEC HOANG GIA --" $fSTc $bG24 ($W/2) 778
$g.DrawString("Trai nghiem Degustation: 01 Cocktail Signature + 01 Kopi Luwak + Pate gan ngong", $fSTcn, $bCrm, [float]78, [float]808)
$g.DrawString("685.000d/cap", $fSTcp, $bG24, [float]($W-220), [float]808)
$g.DrawString("Bao gom: ruou khai vi, thuc don thuong thuc 5 buoc, nhac song piano co dien 18h-21h30", $fSTsl, $bTau, [float]78, [float]856)
$g.DrawString("Dat ban truoc: 1900 9999  -  Phuc vu rieng tu: yeu cau truoc 24 gio", $fSTsl, $bTau, [float]78, [float]882)

$penFootST = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 251, 191, 36), 1.0)
$g.DrawLine($penFootST, 80, 928, $W-80, 928)
$penFootST.Dispose()
DrawCenter $g "SANG TRONG HOANG GIA RESTAURANT  -  Tang 28, Grand Tower" $fSTs $bCrm ($W/2) 958
DrawCenter $g "Reservation: 1900 9999  -  Email: royaldining@smartmenu.vn" $fSTsl $bTau ($W/2) 988

$bmp.Save("$base\SANG_TRONG\sample_1.png", [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host ("   Da luu: SANG_TRONG/sample_1.png  " + $W + "x" + $H)
$g.Dispose(); $bmp.Dispose()
$bG24.Dispose(); $bGSft.Dispose(); $bCrm.Dispose(); $bIvy.Dispose(); $bTau.Dispose()


# ======================================================================
# 3. TRE_TRUNG/sample_1.png — Cute Boba Bar (pastel hong, bo tron)
# ======================================================================
Write-Host "==> Tao TRE_TRUNG/sample_1.png..."
$W = 900; $H = 1150
$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = [System.Drawing.Graphics]::FromImage($bmp)
SetupG $g

$rect3 = New-Object System.Drawing.Rectangle(0, 0, $W, $H)
$grad3 = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect3,
    [System.Drawing.Color]::FromArgb(255, 255, 240, 246),
    [System.Drawing.Color]::FromArgb(255, 253, 232, 241),
    [System.Drawing.Drawing2D.LinearGradientMode]::Vertical)
$g.FillRectangle($grad3, 0, 0, $W, $H)
$grad3.Dispose()

$bCircA = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(40, 219, 39, 119))
$g.FillEllipse($bCircA, -80.0, -80.0, 250.0, 250.0)
$g.FillEllipse($bCircA, [float]($W-150), [float]($H-150), 220.0, 220.0)
$bCircA.Dispose()
$bCircB = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30, 251, 191, 36))
$g.FillEllipse($bCircB, [float]($W-120), -60.0, 200.0, 200.0)
$g.FillEllipse($bCircB, -60.0, [float]($H-130), 180.0, 180.0)
$bCircB.Dispose()

$penRose = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 219, 39, 119), 2.5)
StrokeRR $g $penRose 28 28 ($W-56) ($H-56) 24
$penRose.Dispose()
$penRSoft = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(100, 219, 39, 119), 1.0)
StrokeRR $g $penRSoft 38 38 ($W-76) ($H-76) 18
$penRSoft.Dispose()

$fTTt  = New-Object System.Drawing.Font("Segoe UI", 26, [System.Drawing.FontStyle]::Bold)
$fTTs  = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Regular)
$fTTc  = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$fTTm  = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
$fTTd  = New-Object System.Drawing.Font("Segoe UI", 10.5, [System.Drawing.FontStyle]::Italic)
$fTTsl = New-Object System.Drawing.Font("Segoe UI", 11.5, [System.Drawing.FontStyle]::Regular)
$fTTcp = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$fTTcn = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)

$bRose  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 219, 39, 119))
$bDRose = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 157, 23, 77))
$bPurp  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 168, 85, 247))
$bOrgTT = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 234, 88, 12))
$bDk55  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 50, 35, 45))
$bGy55  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 140, 120, 132))
$bWh55  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$dotTT  = [System.Drawing.Color]::FromArgb(255, 251, 182, 218)

# Header pill
$hdrBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 219, 39, 119))
FillRR $g $hdrBg 60 46 ($W-120) 56 28
$hdrBg.Dispose()
DrawCenter $g "CUTE BOBA VA DESSERT BAR" $fTTt $bWh55 ($W/2) 62

DrawCenter $g "Thuc Don Tra Sua Tran Chau va Do Ngot Tuoi Mat" $fTTs $bDRose ($W/2) 116
DrawCenter $g "Tuy chinh: Duong 0-100%  -  Da it / vua / nhieu  -  Size S / M / L" $fTTs $bGy55 ($W/2) 140

$penDivTT = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 251, 182, 218), 2.0)
$g.DrawLine($penDivTT, 80, 163, $W-80, 163)
$penDivTT.Dispose()
$g.FillEllipse($bRose, [float]($W/2-5), 157.0, 10.0, 10.0)

# CAT 1: TRA SUA TRAN CHAU
$sc1Bg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 240, 246))
FillRR $g $sc1Bg 50 175 ($W-100) 296 16
$sc1Bg.Dispose()
StrokeRR $g (New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 219, 39, 119), 1.5)) 50 175 ($W-100) 296 16

$cp1 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 219, 39, 119))
FillRR $g $cp1 70 163 250 28 14
$cp1.Dispose()
$bWh6 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$g.DrawString("TRA SUA TRAN CHAU", $fTTc, $bWh6, [float]84, [float]173)
$bWh6.Dispose()

$menu5 = @(
    @("Tra Sua Khoai Mon Hoa Dao",  "49.000d", "Khoai mon Da Lat tim beo ngay, tran chau den bui mem"),
    @("Matcha Red Bean Latte",      "52.000d", "Tra xanh Uji pha sua tuoi, dau do ham ngot bui"),
    @("Tra Sua Dua Gang Vang",      "48.000d", "Dua gang ngot thom, sua tuoi mat lanh, thach cau vong"),
    @("Brown Sugar Boba Tran Chau", "52.000d", "Duong nau caramel chay, tran chau nuong deo, sua tuoi"),
    @("Taro Coconut Jelly Crush",   "55.000d", "Cot dua beo quyen khoai mon, thach nha dam gion mat")
)
$ry5 = 200
foreach ($it in $menu5) {
    $g.FillEllipse($bRose, [float]70, [float]($ry5-7), 6.0, 6.0)
    DrawRow $g $it[0] $it[1] $it[2] 70 $ry5 ($W-140) $fTTm $fTTm $fTTd $bDk55 $bOrgTT $bGy55 $dotTT
    $ry5 += 55
}

# CAT 2: NUOC TRAI CAY VA DA XAY
$sc2Bg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 240, 246))
FillRR $g $sc2Bg 50 486 ($W-100) 296 16
$sc2Bg.Dispose()
StrokeRR $g (New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 168, 85, 247), 1.5)) 50 486 ($W-100) 296 16

$cp2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 168, 85, 247))
FillRR $g $cp2 70 474 272 28 14
$cp2.Dispose()
$bWh7 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$g.DrawString("DA XAY VA NUOC TRAI CAY", $fTTc, $bWh7, [float]84, [float]484)
$bWh7.Dispose()

$menu6 = @(
    @("Da Xay Dau Tay Kem Tuoi",   "55.000d", "Dau tay Da Lat tuoi xay min, kem tuoi whip ngot bui"),
    @("Sinh To Xoai Dua Troi Noi", "50.000d", "Xoai cat Hoa Loc chin ngot, nuoc dua tuoi mat lanh"),
    @("Da Xay Phuc Bon Tu Yogurt", "55.000d", "Raspberry tuoi, sua chua Hy Lap sanh min, granola gion"),
    @("Soda Chanh Muoi Viet Nam",  "38.000d", "Chanh tuoi nguyen chat, muoi hong Himalaya, soda sui bot"),
    @("Lemonade Hoa Oai Huong",    "45.000d", "Chanh vang tuoi, siro lavender, soda va mint tuoi mat")
)
$ry6 = 510
foreach ($it in $menu6) {
    $g.FillEllipse($bPurp, [float]70, [float]($ry6-7), 6.0, 6.0)
    DrawRow $g $it[0] $it[1] $it[2] 70 $ry6 ($W-140) $fTTm $fTTm $fTTd $bDk55 $bOrgTT $bGy55 $dotTT
    $ry6 += 55
}

# COMBO CUTE
$cTTbg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 253, 232, 241))
FillRR $g $cTTbg 50 800 ($W-100) 148 16
$cTTbg.Dispose()
StrokeRR $g (New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 219, 39, 119), 2.0)) 50 800 ($W-100) 148 16

$bdgTT = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 234, 88, 12))
FillRR $g $bdgTT 70 787 216 28 14
$bdgTT.Dispose()
$bWh8 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$fBTT = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$g.DrawString("BESTIE COMBO", $fBTT, $bWh8, [float]84, [float]797)
$fBTT.Dispose(); $bWh8.Dispose()

$g.DrawString("Combo Bestie: 02 Tra Sua Bat Ky + 02 Banh Mochi Matcha/Dau", $fTTcn, $bDRose, [float]70, [float]824)
$g.DrawString("89.000d", $fTTcp, $bOrgTT, [float]($W-165), [float]824)
$g.DrawString("Chup anh check-in quán và tag @CuteBoba  -  Giam ngay 10% hoa don tiep theo!", $fTTsl, $bGy55, [float]70, [float]866)
$g.DrawString("Topping mien phi: Tran chau / Thach cau vong / Pudding trung (chon 1)", $fTTsl, $bGy55, [float]70, [float]890)
$g.DrawString("Topping them: Kem cheese (+12k)  -  Pudding them (+8k)  -  Thach nha dam (+8k)", $fTTsl, $bGy55, [float]70, [float]916)

$penFTT = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 219, 39, 119), 1.5)
$g.DrawLine($penFTT, 80, 966, $W-80, 966)
$penFTT.Dispose()
DrawCenter $g "CUTE BOBA BAR  -  Mo cua 09:00 - 23:00 moi ngay" $fTTs $bDRose ($W/2) 994
DrawCenter $g "Hotline: 1900 2468  -  Instagram: @CuteBoba  -  Wifi: BoBa_Free" $fTTsl $bGy55 ($W/2) 1022

$bmp.Save("$base\TRE_TRUNG\sample_1.png", [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host ("   Da luu: TRE_TRUNG/sample_1.png  " + $W + "x" + $H)
$g.Dispose(); $bmp.Dispose()
$bRose.Dispose(); $bDRose.Dispose(); $bPurp.Dispose(); $bOrgTT.Dispose()
$bDk55.Dispose(); $bGy55.Dispose(); $bWh55.Dispose()


# ======================================================================
# 4. TRUYEN_THONG/sample_1.png — Quan Ca Phe San Vuon Viet (parchment co dien)
# ======================================================================
Write-Host "==> Tao TRUYEN_THONG/sample_1.png..."
$W = 800; $H = 1100
$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = [System.Drawing.Graphics]::FromImage($bmp)
SetupG $g

$rect4 = New-Object System.Drawing.Rectangle(0, 0, $W, $H)
$grad4 = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect4,
    [System.Drawing.Color]::FromArgb(255, 253, 244, 220),
    [System.Drawing.Color]::FromArgb(255, 247, 234, 200),
    [System.Drawing.Drawing2D.LinearGradientMode]::Vertical)
$g.FillRectangle($grad4, 0, 0, $W, $H)
$grad4.Dispose()

$penBr1 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 120, 53, 15), 4.0)
$g.DrawRectangle($penBr1, 20, 20, $W-40, $H-40)
$penBr1.Dispose()
$penBr2 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 120, 53, 15), 1.5)
$g.DrawRectangle($penBr2, 32, 32, $W-64, $H-64)
$penBr2.Dispose()

$penCBr = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 120, 53, 15), 2.0)
$csR = 28
$g.DrawLine($penCBr, 42, 42, 42+$csR, 42);     $g.DrawLine($penCBr, 42, 42, 42, 42+$csR)
$g.DrawLine($penCBr, 42+8, 42+8, 42+$csR-4, 42+8)
$g.DrawLine($penCBr, $W-42-$csR, 42, $W-42, 42); $g.DrawLine($penCBr, $W-42, 42, $W-42, 42+$csR)
$g.DrawLine($penCBr, $W-42-$csR+4, 42+8, $W-42-8, 42+8)
$g.DrawLine($penCBr, 42, $H-42-$csR, 42, $H-42); $g.DrawLine($penCBr, 42, $H-42, 42+$csR, $H-42)
$g.DrawLine($penCBr, 42+8, $H-42-8, 42+8, $H-42-$csR+4)
$g.DrawLine($penCBr, $W-42-$csR, $H-42, $W-42, $H-42); $g.DrawLine($penCBr, $W-42, $H-42-$csR, $W-42, $H-42)
$g.DrawLine($penCBr, $W-42-$csR+4, $H-42-8, $W-42-8, $H-42-8)
$penCBr.Dispose()

$fTRtg = New-Object System.Drawing.Font("Georgia", 11, [System.Drawing.FontStyle]::Italic)
$fTRtt = New-Object System.Drawing.Font("Georgia", 27, [System.Drawing.FontStyle]::Bold)
$fTRsb = New-Object System.Drawing.Font("Georgia", 13, [System.Drawing.FontStyle]::Italic)
$fTRct = New-Object System.Drawing.Font("Georgia", 14, [System.Drawing.FontStyle]::Bold)
$fTRmn = New-Object System.Drawing.Font("Georgia", 12.5, [System.Drawing.FontStyle]::Bold)
$fTRdc = New-Object System.Drawing.Font("Georgia", 10, [System.Drawing.FontStyle]::Italic)
$fTRsl = New-Object System.Drawing.Font("Georgia", 11, [System.Drawing.FontStyle]::Regular)
$fTRcb = New-Object System.Drawing.Font("Georgia", 13, [System.Drawing.FontStyle]::Bold)
$fTRcp = New-Object System.Drawing.Font("Georgia", 17, [System.Drawing.FontStyle]::Bold)

$bSepia  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 120, 53, 15))
$bBrown  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 68, 26, 8))
$bAmbrTR = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 180, 83, 9))
$bWarmTR = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 150, 130, 100))
$dotTR   = [System.Drawing.Color]::FromArgb(255, 200, 170, 120)

DrawCenter $g "— Quan Ca Phe San Vuon —" $fTRtg $bSepia ($W/2) 48
DrawCenter $g "TRUYEN THONG CO DIEN" $fTRtt $bBrown ($W/2) 80
DrawCenter $g "Huong Vi Thuan Viet — Noi Luu Giu Ky Uc" $fTRsb $bSepia ($W/2) 120

$penDivTR = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 150, 100, 50), 1.5)
$g.DrawLine($penDivTR, 80, 146, $W-80, 146)
$penDivTR.Dispose()
DrawCenter $g "—  —" $fTRtg $bSepia ($W/2) 154

# CAT 1
$g.DrawString("CA PHE TRUYEN THONG VIET NAM", $fTRct, $bBrown, [float]52, [float]178)
$penTRC1 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 120, 53, 15), 1.5)
$g.DrawLine($penTRC1, 52, 198, $W-52, 198)
$penTRC1.Dispose()

$menu7 = @(
    @("Ca Phe Sua Da Kem Phin",      "35.000d", "Pha phin nho giot cham, da vien to, sua dac ong Tho"),
    @("Ca Phe Den Da Dam Vi",        "28.000d", "Robusta Buon Ma Thuot rang dam, hau vi dang hoa qua"),
    @("Bac Xiu Sua Kem Tuoi",        "38.000d", "Ca phe phin loang, sua tuoi am, kem tuoi phu mat"),
    @("Ca Phe Trung Ha Noi",         "42.000d", "Cong thuc truyen thong Ha Noi, kem trung danh bong"),
    @("Ca Phe Dua Dac San Hoi An",   "45.000d", "Dac san pho Hoi, cot dua Ben Tre beo sanh, da xay min"),
    @("Ca Phe Chon Cam Thach",       "95.000d", "Hat ca phe chon thuan chung, vi bo ngot hau vi thanh")
)
$ry7 = 212
foreach ($it in $menu7) {
    $bDotTR = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 120, 53, 15))
    $g.FillEllipse($bDotTR, [float]52, [float]($ry7-7), 5.0, 5.0)
    $bDotTR.Dispose()
    DrawRow $g $it[0] $it[1] $it[2] 52 $ry7 ($W-104) $fTRmn $fTRmn $fTRdc $bBrown $bAmbrTR $bWarmTR $dotTR
    $ry7 += 50
}

# CAT 2
$g.DrawString("TRA HO VA NUOC GIAI KHAT TRUYEN THONG", $fTRct, $bBrown, [float]52, [float]534)
$penTRC2 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 120, 53, 15), 1.5)
$g.DrawLine($penTRC2, 52, 554, $W-52, 554)
$penTRC2.Dispose()

$menu8 = @(
    @("Tra Da Mien Nam Thuan Tuy",   "18.000d", "Tra O long manh pha nuoc soi, da cuc to mat lanh"),
    @("Tra Sen Ho Tay Thuong Hang",  "55.000d", "Tra xanh uop sen bach diep Ho Tay, huong hoa thanh khiet"),
    @("Nuoc Chanh Mat Ong Gung",     "32.000d", "Chanh tuoi vat, mat ong nguyen chat, gung cay am bung"),
    @("Nuoc Mia Sa Chanh Tuoi",      "25.000d", "Mia Hau Giang ep tuoi, sa dap dap, chanh tuoi va da vien"),
    @("Sam Bo Luong Ngoc Trai",      "38.000d", "Bot bang, hat sen, tao do, long nhan, duong phen mat")
)
$ry8 = 568
foreach ($it in $menu8) {
    $bDotTR2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 180, 83, 9))
    $g.FillEllipse($bDotTR2, [float]52, [float]($ry8-7), 5.0, 5.0)
    $bDotTR2.Dispose()
    DrawRow $g $it[0] $it[1] $it[2] 52 $ry8 ($W-104) $fTRmn $fTRmn $fTRdc $bBrown $bAmbrTR $bWarmTR $dotTR
    $ry8 += 48
}

# COMBO
$cTRbg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 244, 228, 188))
FillRR $g $cTRbg 52 822 ($W-104) 140 8
$cTRbg.Dispose()
StrokeRR $g (New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 120, 53, 15), 1.5)) 52 822 ($W-104) 140 8

DrawCenter $g "— Combo Sang Som Dac Biet —" $fTRct $bBrown ($W/2) 842
$g.DrawString("01 Ca Phe Sua Da + 01 Banh Mi Pate va Trung Op La Gion", $fTRcb, $bBrown, [float]68, [float]870)
DrawRight $g "55.000d" $fTRcp $bAmbrTR [float]($W-54) 870
$g.DrawString("Phuc vu 06:30 - 10:30  -  An tai quan  -  Tiet kiem 12.000d", $fTRsl, $bWarmTR, [float]68, [float]906)
$g.DrawString("Them: Banh croissant (+15k)  -  Them trung (+8k)  -  Nuoc cam vat (+12k)", $fTRsl, $bWarmTR, [float]68, [float]930)

$penFTR = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 120, 53, 15), 1.5)
$g.DrawLine($penFTR, 80, 982, $W-80, 982)
$penFTR.Dispose()
DrawCenter $g "CA PHE TRUYEN THONG — Noi Ket Noi The He" $fTRsb $bSepia ($W/2) 1012
DrawCenter $g "Mo cua 06:30 – 21:30  -  Vỉa he san vuon  -  Hotline: 1900 5555" $fTRsl $bWarmTR ($W/2) 1042

$bmp.Save("$base\TRUYEN_THONG\sample_1.png", [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host ("   Da luu: TRUYEN_THONG/sample_1.png  " + $W + "x" + $H)
$g.Dispose(); $bmp.Dispose()
$bSepia.Dispose(); $bBrown.Dispose(); $bAmbrTR.Dispose(); $bWarmTR.Dispose()

Write-Host ""
Write-Host "===== HOAN TAT TAO 4 MENU MAU ====="
Write-Host "  HIEN_DAI/sample_1.png    — Modern Espresso Bar (navy toi, cyan)"
Write-Host "  SANG_TRONG/sample_1.png  — Fine Dining Cocktail (den espresso, vang)"
Write-Host "  TRE_TRUNG/sample_1.png   — Cute Boba Bar (pastel hong)"
Write-Host "  TRUYEN_THONG/sample_1.png — Quan Ca Phe Viet (parchment nau co dien)"
