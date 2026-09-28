Add-Type -AssemblyName System.Drawing

$basePath = "c:\Users\ASUS\Downloads\Smart_Menu\Smart_Menu\backend\src\main\resources\menu-style"
$targetPath = "c:\Users\ASUS\Downloads\Smart_Menu\Smart_Menu\backend\target\classes\menu-style"

# =============================================================================================
# HELPER FUNCTIONS
# =============================================================================================
function DrawCenteredString($g, $text, $font, $brush, $centerX, $y) {
    $size = $g.MeasureString($text, $font)
    $x = $centerX - ($size.Width / 2)
    $g.DrawString($text, $font, $brush, [float]$x, [float]$y)
}

function DrawLeaderDots($g, $x1, $x2, $y, $color) {
    $dotBrush = New-Object System.Drawing.SolidBrush($color)
    $dx = $x1
    while ($dx -lt $x2) {
        $g.FillRectangle($dotBrush, [float]$dx, [float]($y - 4), 2.0, 2.0)
        $dx += 7
    }
    $dotBrush.Dispose()
}

function DrawRoundedRect($g, $pen, $x, $y, $w, $h, $radius) {
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddArc($x, $y, $radius*2, $radius*2, 180, 90)
    $path.AddArc($x + $w - $radius*2, $y, $radius*2, $radius*2, 270, 90)
    $path.AddArc($x + $w - $radius*2, $y + $h - $radius*2, $radius*2, $radius*2, 0, 90)
    $path.AddArc($x, $y + $h - $radius*2, $radius*2, $radius*2, 90, 90)
    $path.CloseFigure()
    $g.DrawPath($pen, $path)
    $path.Dispose()
}

function FillRoundedRect($g, $brush, $x, $y, $w, $h, $radius) {
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddArc($x, $y, $radius*2, $radius*2, 180, 90)
    $path.AddArc($x + $w - $radius*2, $y, $radius*2, $radius*2, 270, 90)
    $path.AddArc($x + $w - $radius*2, $y + $h - $radius*2, $radius*2, $radius*2, 0, 90)
    $path.AddArc($x, $y + $h - $radius*2, $radius*2, $radius*2, 90, 90)
    $path.CloseFigure()
    $g.FillPath($brush, $path)
    $path.Dispose()
}

function DrawMenuItem($g, $name, $price, $desc, $x, $y, $maxW, $nameFont, $priceFont, $descFont, $nameColor, $priceColor, $descColor, $dotColor) {
    # Ten mon
    $g.DrawString($name, $nameFont, $nameColor, [float]($x + 14), [float]$y)
    # Gia tien
    $priceSize = $g.MeasureString($price, $priceFont)
    $priceX = $x + $maxW - $priceSize.Width - 4
    $g.DrawString($price, $priceFont, $priceColor, [float]$priceX, [float]$y)
    # Cham noi
    $nameSize = $g.MeasureString($name, $nameFont)
    $dotStart = $x + 16 + $nameSize.Width
    $dotEnd = $priceX - 6
    if ($dotEnd -gt $dotStart) { DrawLeaderDots $g $dotStart $dotEnd ($y + 12) $dotColor }
    # Mo ta
    if ($desc -ne "") {
        $g.DrawString($desc, $descFont, $descColor, [float]($x + 14), [float]($y + 18))
    }
}

# =============================================================================================
# STYLE 1: NHIET_DOI - Nhiet Doi Tuoi Mat (Tropical Fresh Bar)
# Nen xanh la rung nhiet doi dam, chu vang xoai & xanh bac ha, khung vang amber sang trong
# =============================================================================================
Write-Host "==> Dang tao style NHIET_DOI..."

$W = 1024; $H = 1366
$bmp = New-Object System.Drawing.Bitmap($W, $H, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality

# 1. Nen gradient xanh rung nhiet doi
$rect = New-Object System.Drawing.Rectangle(0, 0, $W, $H)
$gradBg = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $rect,
    [System.Drawing.Color]::FromArgb(255, 5, 42, 32),
    [System.Drawing.Color]::FromArgb(255, 10, 70, 52),
    [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
)
$g.FillRectangle($gradBg, 0, 0, $W, $H)
$gradBg.Dispose()

# Hoa van la cay nhiet doi bong mo nền
$leafBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30, 20, 100, 70))
for ($i = 0; $i -lt 5; $i++) {
    $g.FillEllipse($leafBrush, [float](-80 + $i*220), -70.0, 280.0, 180.0)
    $g.FillEllipse($leafBrush, [float]($W - 180 - $i*160), [float]($H - 130), 300.0, 220.0)
}
$leafBrush.Dispose()

# 2. Khung vien vang amber sang trong
$penOuter = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 245, 158, 11), 2.0)
DrawRoundedRect $g $penOuter 28 28 ($W-56) ($H-56) 22
$penInner = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(100, 254, 243, 199), 1.0)
DrawRoundedRect $g $penInner 38 38 ($W-76) ($H-76) 16
$penOuter.Dispose()
$penInner.Dispose()

# 3. HEADER - Ten quan
$brushGold = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 245, 158, 11))
$brushCream = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 254, 243, 199))
$brushMint = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 52, 211, 153))
$brushWhite = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$brushGray = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 167, 243, 208))
$brushDark = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 209, 250, 229))
$brushPrice1 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 251, 191, 36))

$fontTagline = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
$fontTitle   = New-Object System.Drawing.Font("Arial", 38, [System.Drawing.FontStyle]::Bold)
$fontSubtitle= New-Object System.Drawing.Font("Segoe UI", 15, [System.Drawing.FontStyle]::Bold)
$fontCatHdr  = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$fontCatEn   = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$fontItem    = New-Object System.Drawing.Font("Segoe UI", 13.5, [System.Drawing.FontStyle]::Bold)
$fontDesc    = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Italic)
$fontSmall   = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Regular)
$fontFooter  = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)

DrawCenteredString $g "FRESH & NATURAL 100%  |  THUC UONG NHIET DOI TUOI NGON" $fontTagline $brushGold ($W/2) 72
DrawCenteredString $g "TROPICAL FRESH BAR" $fontTitle $brushCream ($W/2) 120
DrawCenteredString $g "MENU TRA HOA QUA TUOI & DA XAY NHIET DOI" $fontSubtitle $brushMint ($W/2) 162

# Duong ke phan cach vang
$penGold = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 245, 158, 11), 1.5)
$g.DrawLine($penGold, 110, 186, $W-110, 186)
$g.FillEllipse($brushGold, ($W/2 - 5), 181, 10, 10)
$penGold.Dispose()

# 4. 2 COT DANH MUC
# COT 1: TRA TRAI CAY TUOI
$col1X = 58; $col1W = 432; $startY = 240
$bg1 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(160, 8, 50, 38))
FillRoundedRect $g $bg1 $col1X $startY $col1W 560 14
$bg1.Dispose()
$penCard1 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(90, 16, 185, 129), 1.2)
DrawRoundedRect $g $penCard1 $col1X $startY $col1W 560 14
$penCard1.Dispose()

$g.DrawString("TRA HOA QUA TUOI", $fontCatHdr, $brushMint, [float]($col1X+16), [float]($startY+28))
$g.DrawString("TROPICAL FRUIT TEA", $fontCatEn, $brushDark, [float]($col1X+16), [float]($startY+52))
$accentBrush1 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 16, 185, 129))
$g.FillRectangle($accentBrush1, [float]($col1X+16), [float]($startY+64), 55.0, 3.0)
$accentBrush1.Dispose()

$dotColorTea = [System.Drawing.Color]::FromArgb(80, 245, 158, 11)
$items1 = @(
    @("Tra Dao Cam Sa Tuoi",    "45.000d", "Dao gion vang mong, cam vang & sa dap dap thom the"),
    @("Tra Mang Cau Xiem",      "48.000d", "Thit mang cau tuoi dam vi, ngot mat nhiet doi"),
    @("Tra Vai Hoa Hong Tuyet", "48.000d", "Vai thieu mong ngot, huong nup hoa hong say kho"),
    @("Tra Xoai Chanh Leo",     "49.000d", "Xoai chin ngot lim ket hop cot chanh leo chua thanh"),
    @("Tra Dua Hau Bac Ha",     "46.000d", "Nuoc ep dua hau tuoi mat, tinh dau bac ha the mat"),
    @("Tra Buoi Hong Mat Ong",  "49.000d", "Tep buoi hong tuoi mong, mat ong rung diu em"),
    @("Tra Dau Tam Pha Le",     "47.000d", "Dau tam Da Lat chua ngot song sanh, thach ngoc trai")
)
$curY = $startY + 82
foreach ($it in $items1) {
    $g.FillEllipse($brushMint, [float]($col1X+16), [float]($curY-7), 6.0, 6.0)
    DrawMenuItem $g $it[0] $it[1] $it[2] ($col1X+16) $curY ($col1W-32) $fontItem $fontItem $fontDesc $brushWhite $brushPrice1 $brushGray $dotColorTea
    $curY += 68
}

# COT 2: SINH TO & DA TUYET
$col2X = 534; $col2W = 432
$bg2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(160, 8, 50, 38))
FillRoundedRect $g $bg2 $col2X $startY $col2W 560 14
$bg2.Dispose()
$penCard2 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(90, 245, 158, 11), 1.2)
DrawRoundedRect $g $penCard2 $col2X $startY $col2W 560 14
$penCard2.Dispose()

$g.DrawString("SINH TO & DA TUYET", $fontCatHdr, $brushGold, [float]($col2X+16), [float]($startY+28))
$g.DrawString("SMOOTHIE & ICE BLENDED", $fontCatEn, $brushDark, [float]($col2X+16), [float]($startY+52))
$accentBrush2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 245, 158, 11))
$g.FillRectangle($accentBrush2, [float]($col2X+16), [float]($startY+64), 55.0, 3.0)
$accentBrush2.Dispose()

$items2 = @(
    @("Sinh To Bo Sap Dua Non",   "55.000d", "Bo sap Dak Lak day quanh xay cung nuoc cot dua beo ngay"),
    @("Da Tuyet Xoai Cot Dua",    "52.000d", "Xoai Cat Chu ngot lim phu lop cot dua Ben Tre sanh min"),
    @("Sinh To Mang Cau Sua Chua","50.000d", "Mang cau tuoi ket hop sua chua Hy Lap thom diu"),
    @("Nuoc Ep Thom Oi Hong",     "45.000d", "Ep cham nguyen chat giau vitamin C, khong them duong"),
    @("Ca Phe Cot Dua Da Xay",    "49.000d", "Ca phe Robusta thom dam quyen dua da xay tuyet"),
    @("Chanh Leo Tuyet Bac Ha",   "42.000d", "Vi chua bung no, da tuyet mat lanh sang khoai ngay he"),
    @("Sinh To Dau Chuoi Yen Mach","52.000d","Dau tay tuoi, chuoi gia & yen mach bo duong no lau")
)
$curY = $startY + 82
$brushMintPrice = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 52, 211, 153))
foreach ($it in $items2) {
    $g.FillEllipse($brushGold, [float]($col2X+16), [float]($curY-7), 6.0, 6.0)
    DrawMenuItem $g $it[0] $it[1] $it[2] ($col2X+16) $curY ($col2W-32) $fontItem $fontItem $fontDesc $brushWhite $brushMintPrice $brushGray $dotColorTea
    $curY += 68
}
$brushMintPrice.Dispose()

# 5. KHUNG COMBO SUMMER DEAL
$comboY = 832; $comboH = 160
$comboBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(200, 10, 58, 46))
FillRoundedRect $g $comboBg 58 $comboY ($W-116) $comboH 16
$comboBg.Dispose()
$penCombo = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 245, 158, 11), 1.5)
DrawRoundedRect $g $penCombo 58 $comboY ($W-116) $comboH 16
$penCombo.Dispose()

# Badge HOT PROMO
$badgeBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 225, 29, 72))
FillRoundedRect $g $badgeBrush 82 ($comboY-14) 200 28 14
$badgeBrush.Dispose()
$fontBadge = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$g.DrawString("SUMMER DEAL COMBO", $fontBadge, $brushWhite, [float]98, [float]($comboY-4))

$fontComboName = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$fontComboPrice = New-Object System.Drawing.Font("Segoe UI", 26, [System.Drawing.FontStyle]::Bold)
$brushRed = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 225, 29, 72))

$g.DrawString("Combo Doi Giai Nhiet: 02 Ly Tra Trai Cay Tu Chon", $fontComboName, $brushCream, [float]82, [float]($comboY+38))
$g.DrawString("79.000d", $fontComboPrice, $brushPrice1, [float]($W-210), [float]($comboY+42))

$g.DrawString("Tiet kiem den 20% khi di cung ban be  (Gia goc: 98.000d)", $fontSmall, $brushDark, [float]82, [float]($comboY+76))
$g.DrawString("Topping: Tran chau (+10k)  |  Thach nha dam (+8k)  |  Dao mieng (+12k)  |  Hat chia (+8k)", $fontSmall, $brushGray, [float]82, [float]($comboY+102))
$g.DrawString("Tuy chinh: Duong 0%/30%/50%/70%  |  Da rieng / 50% / Day", $fontSmall, $brushGray, [float]82, [float]($comboY+128))

$brushRed.Dispose()

# 6. 3 O LOI ICH SUC KHOE
$bY = 1016; $bW = ([int](($W - 116 - 24) / 3))
$benefitBgs = @(
    [System.Drawing.Color]::FromArgb(255, 16, 185, 129),
    [System.Drawing.Color]::FromArgb(255, 245, 158, 11),
    [System.Drawing.Color]::FromArgb(255, 244, 114, 182)
)
$benefitTitles = @("100% TRAI CAY TUOI", "KHONG CHAT BAO QUAN", "DUONG MIA TU NHIEN")
$benefitDescs = @(
    "Nong san tuoi sach tu cac nong trai huu co Da Lat & Tien Giang.",
    "Pha che truc tiep trong ngay, giu tron ven chat chong oxy hoa tu nhien.",
    "Duong phen & mat ong hoa rung nguyen chat, vi ngot thanh mat lanh."
)
for ($bi = 0; $bi -lt 3; $bi++) {
    $bx = 58 + $bi * ($bW + 12)
    $bBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(160, 8, 55, 42))
    FillRoundedRect $g $bBg $bx $bY $bW 120 12
    $bBg.Dispose()
    $pen3 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(60, 16, 185, 129), 1.0)
    DrawRoundedRect $g $pen3 $bx $bY $bW 120 12
    $pen3.Dispose()
    $badgeAccent = New-Object System.Drawing.SolidBrush($benefitBgs[$bi])
    $fontBTitle = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    $g.DrawString($benefitTitles[$bi], $fontBTitle, $badgeAccent, [float]($bx+14), [float]($bY+26))
    $badgeAccent.Dispose()
    $fontBTitle.Dispose()
    $g.DrawString($benefitDescs[$bi], $fontDesc, $brushGray, [float]($bx+14), [float]($bY+50))
}

# 7. FOOTER
$penFooter = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(100, 245, 158, 11), 1.5)
$g.DrawLine($penFooter, 80, 1160, $W-80, 1160)
$penFooter.Dispose()

DrawCenteredString $g "TROPICAL FRESH BAR  -  MANG CA THIEN NHIEN NHIET DOI DEN BAN" $fontFooter $brushCream ($W/2) 1194
DrawCenteredString $g "Gio hoat dong: 07:30 - 23:00  |  Freeship don tu 100k  |  Hotline: 1900 8989" $fontSmall $brushGray ($W/2) 1224
DrawCenteredString $g "Website: tropicalbar.smartmenu.vn  |  Wifi: TropicalBar_Free" $fontSmall $brushGray ($W/2) 1250

# Luu anh NHIET_DOI
$dirNhietDoi = "$basePath\NHIET_DOI"
if (-not (Test-Path $dirNhietDoi)) { New-Item -ItemType Directory -Path $dirNhietDoi | Out-Null }
$outNhietDoi = "$dirNhietDoi\reference.png"
$bmp.Save($outNhietDoi, [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host "Da luu: $outNhietDoi ($W x $H)"
$g.Dispose(); $bmp.Dispose()

# Dong resources
$brushGold.Dispose(); $brushCream.Dispose(); $brushMint.Dispose(); $brushWhite.Dispose()
$brushGray.Dispose(); $brushDark.Dispose(); $brushPrice1.Dispose()


# =============================================================================================
# STYLE 2: MINIMAL - Toi Gian Tinh Te (Minimalist Scandinavian Cafe)
# Nen giay kem nha, chu den lich su, vien khung mong, khong gian thoang dat
# =============================================================================================
Write-Host "==> Dang tao style MINIMAL..."

$W = 1000; $H = 1400
$bmp2 = New-Object System.Drawing.Bitmap($W, $H, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g2 = [System.Drawing.Graphics]::FromImage($bmp2)
$g2.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g2.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$g2.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality

# 1. Nen kem nha Linen cao cap
$g2.Clear([System.Drawing.Color]::FromArgb(255, 250, 248, 244))

# 2. Khung vien doi phong cach Scandinavian tinh te
$penBorderOuter = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 225, 218, 206), 1.0)
$g2.DrawRectangle($penBorderOuter, 30, 30, $W-60, $H-60)
$penBorderOuter.Dispose()
$penBorderInner = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 50, 48, 45), 1.8)
$g2.DrawRectangle($penBorderInner, 40, 40, $W-80, $H-80)
$penBorderInner.Dispose()

# Goc trang tri
$penCorner = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 180, 140, 75), 2.0)
$cs = 20
# Goc tren trai
$g2.DrawLine($penCorner, 48, 48, (48+$cs), 48); $g2.DrawLine($penCorner, 48, 48, 48, (48+$cs))
# Goc tren phai
$g2.DrawLine($penCorner, ($W-48-$cs), 48, ($W-48), 48); $g2.DrawLine($penCorner, ($W-48), 48, ($W-48), (48+$cs))
# Goc duoi trai
$g2.DrawLine($penCorner, 48, ($H-48-$cs), 48, ($H-48)); $g2.DrawLine($penCorner, 48, ($H-48), (48+$cs), ($H-48))
# Goc duoi phai
$g2.DrawLine($penCorner, ($W-48-$cs), ($H-48), ($W-48), ($H-48)); $g2.DrawLine($penCorner, ($W-48), ($H-48-$cs), ($W-48), ($H-48))
$penCorner.Dispose()

# 3. HEADER
$brushGold2   = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 180, 140, 75))
$brushBlack2  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 30, 28, 26))
$brushBrown2  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 120, 115, 105))
$brushOrange2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 170, 70, 20))
$brushDesc2   = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 125, 118, 108))
$brushDot2    = [System.Drawing.Color]::FromArgb(255, 205, 195, 180)

$fontHeaderTag = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$fontTitle2    = New-Object System.Drawing.Font("Georgia", 36, [System.Drawing.FontStyle]::Bold)
$fontSub2      = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Regular)
$fontCatHead2  = New-Object System.Drawing.Font("Georgia", 19, [System.Drawing.FontStyle]::Bold)
$fontCatEn2    = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$fontItem2     = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$fontDesc2     = New-Object System.Drawing.Font("Segoe UI", 11.5, [System.Drawing.FontStyle]::Italic)
$fontSmall2    = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Regular)
$fontFooter2   = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)

DrawCenteredString $g2 "ESTABLISHED  2024" $fontHeaderTag $brushGold2 ($W/2) 80
DrawCenteredString $g2 "THE MINIMALIST CAFE" $fontTitle2 $brushBlack2 ($W/2) 128
DrawCenteredString $g2 "ARTISAN COFFEE & SPECIALTY TEA  |  BANG GIA THUC UONG" $fontSub2 $brushBrown2 ($W/2) 164

# Duong ke + kim cuong phan cach
$penDivider = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 200, 192, 180), 1.0)
$g2.DrawLine($penDivider, 150, 188, $W-150, 188)
$penDivider.Dispose()
# Kim cuong nho chinh giua
$ptDiamond = @(
    (New-Object System.Drawing.Point(($W/2), 180)),
    (New-Object System.Drawing.Point(($W/2 + 7), 188)),
    (New-Object System.Drawing.Point(($W/2), 196)),
    (New-Object System.Drawing.Point(($W/2 - 7), 188))
)
$g2.FillPolygon($brushGold2, $ptDiamond)

# 4. 2 COT DANH MUC
$c1X = 68; $c1W = 412; $c2X = 520; $c2W = 412; $sY = 240

# --- COT 1: CA PHE DAC SAN ---
$g2.DrawString("CA PHE DAC SAN", $fontCatHead2, $brushBlack2, [float]$c1X, [float]$sY)
$g2.DrawString("SPECIALTY COFFEE", $fontCatEn2, $brushGold2, [float]$c1X, [float]($sY+24))
$penCatLine = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 40, 36, 32), 1.5)
$g2.DrawLine($penCatLine, $c1X, ($sY+36), ($c1X+$c1W), ($sY+36))
$penCatLine.Dispose()

$coffeeMenu = @(
    @("Ca Phe Muoi Co Do",        "39.000d", "Kem muoi bien beo ngay, hat Robusta Buon Ma Thuot"),
    @("Cold Brew Cam Vang",       "45.000d", "Ca phe u lanh 24h ket hop cam vang say moc"),
    @("Espresso Tonic Mat Lanh",  "42.000d", "Espresso duom vi hoa quyen sui bot Tonic & chanh"),
    @("Ca Phe Sua Hanh Nhan",     "45.000d", "Sua hanh nhan nguyen chat, thom bui thanh nhe"),
    @("Bac Xiu Sua Dua Beo",      "42.000d", "Cot dua Ben Tre tuoi sanh min cung ca phe phin"),
    @("Americano Que Mat Ong",    "38.000d", "Americano dam huong thanh tao, mat ong hoa rung"),
    @("Latte Yen Mach Nuong",     "48.000d", "Oat milk nhap khau, bot sua min mang chuan Y")
)
$curY2 = $sY + 52
foreach ($it in $coffeeMenu) {
    $g2.FillEllipse($brushGold2, [float]($c1X), [float]($curY2-9), 5.0, 5.0)
    DrawMenuItem $g2 $it[0] $it[1] $it[2] ($c1X) $curY2 $c1W $fontItem2 $fontItem2 $fontDesc2 $brushBlack2 $brushOrange2 $brushDesc2 $brushDot2
    $curY2 += 68
}

# --- COT 2: TRA HOA & MATCHA ---
$g2.DrawString("TRA HOA & MATCHA", $fontCatHead2, $brushBlack2, [float]$c2X, [float]$sY)
$g2.DrawString("ORGANIC TEA & MATCHA", $fontCatEn2, $brushGold2, [float]$c2X, [float]($sY+24))
$penCatLine2 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 40, 36, 32), 1.5)
$g2.DrawLine($penCatLine2, $c2X, ($sY+36), ($c2X+$c2W), ($sY+36))
$penCatLine2.Dispose()

$teaMenu = @(
    @("Matcha Latte Uji Kyoto",    "52.000d", "Bot tra xanh Uji cao cap chuan Nhat Ban"),
    @("Tra O Long Sen Vang",       "48.000d", "Hat sen Hue bui ngot, kem pho mai Macchiato"),
    @("Tra Vai Hoa Hong Ruby",     "46.000d", "Vai thieu mong nuoc, huong nup hoa hong say"),
    @("Tra Dao Cam Sa Tuoi",       "45.000d", "Dao gion vang uom, sa dap dap thom the mat"),
    @("Luc Tra Mang Cau Xiem",     "48.000d", "Mang cau dam tuoi nguyen chat, vi chua ngot diu"),
    @("Houjicha Sua Nuong",        "50.000d", "Tra rang la co truyen Nhat, vi khoi hat phi"),
    @("Tra Sua Oolong Nuong",      "45.000d", "Vi tra dam da, thom lung huong caramel nuong")
)
$curY3 = $sY + 52
foreach ($it in $teaMenu) {
    $g2.FillEllipse($brushGold2, [float]($c2X), [float]($curY3-9), 5.0, 5.0)
    DrawMenuItem $g2 $it[0] $it[1] $it[2] $c2X $curY3 $c2W $fontItem2 $fontItem2 $fontDesc2 $brushBlack2 $brushOrange2 $brushDesc2 $brushDot2
    $curY3 += 68
}

# 5. KHUNG COMBO DAC QUYEN
$promoY = 832; $promoH = 165
$promoBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 242, 237, 227))
FillRoundedRect $g2 $promoBg 68 $promoY ($W-136) $promoH 12
$promoBg.Dispose()
$penPromo = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 205, 195, 180), 1.2)
DrawRoundedRect $g2 $penPromo 68 $promoY ($W-136) $promoH 12
$penPromo.Dispose()

# Badge SIGNATURE COMBO
$badgeBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 180, 140, 75))
FillRoundedRect $g2 $badgeBg 90 ($promoY-14) 200 28 14
$badgeBg.Dispose()
$brushWhite2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$fontBadge2 = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$g2.DrawString("SIGNATURE COMBO", $fontBadge2, $brushWhite2, [float]106, [float]($promoY-4))
$fontBadge2.Dispose()

$fontComboName2 = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$fontComboPrice2 = New-Object System.Drawing.Font("Segoe UI", 22, [System.Drawing.FontStyle]::Bold)
$brushOrange3 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 180, 100, 40))
$g2.DrawString("Combo Thu Thai: 01 Ca Phe Muoi + 01 Banh Croissant Bo Phap", $fontComboName2, $brushBlack2, [float]90, [float]($promoY+44))
$g2.DrawString("65.000d", $fontComboPrice2, $brushOrange3, [float]($W-195), [float]($promoY+44))
$g2.DrawString("(Tiet kiem 20.000d)", $fontSmall2, $brushBrown2, [float]($W-210), [float]($promoY+72))
$g2.DrawString("TOPPING THEM: Tran chau ngoc trai (+10k)  |  Kem Cheese (+12k)  |  Hat sen ngot (+10k)", $fontSmall2, $brushBrown2, [float]90, [float]($promoY+104))
$g2.DrawString("DIEU CHINH: 30% / 50% / 70% Duong & Da theo khau vi cua ban.", $fontSmall2, $brushBrown2, [float]90, [float]($promoY+132))
$brushOrange3.Dispose(); $fontComboName2.Dispose(); $fontComboPrice2.Dispose()

# 6. 3 O CAM KET CHAT LUONG
$bY2 = 1020; $bW2 = ([int](($W - 136 - 24) / 3))
$fBoxTitles = @("100% CA PHE MOC", "TRA HAI TAY MOC CHAU", "SUA HAT NGUYEN CHAT")
$fBoxDescs = @(
    "Hat Arabica Cau Dat & Robusta hanh chin 100%, rang xay tuoi moi moi tuan.",
    "La tra O long & Luc tra thuong hang, u lanh chiet xuat huong hoa tu nhien.",
    "Sua yen mach & sua hanh nhan tuoi lanh, thuan thuc vat tot cho suc khoe."
)
for ($fi = 0; $fi -lt 3; $fi++) {
    $fx = 68 + $fi * ($bW2 + 12)
    $fBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 246, 242, 235))
    FillRoundedRect $g2 $fBg $fx $bY2 $bW2 120 8
    $fBg.Dispose()
    $fPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 220, 212, 200), 1.0)
    DrawRoundedRect $g2 $fPen $fx $bY2 $bW2 120 8
    $fPen.Dispose()
    $fTitleFont = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    $g2.DrawString($fBoxTitles[$fi], $fTitleFont, $brushGold2, [float]($fx+14), [float]($bY2+28))
    $fTitleFont.Dispose()
    $g2.DrawString($fBoxDescs[$fi], $fontDesc2, $brushDesc2, [float]($fx+14), [float]($bY2+50))
}

# 7. FOOTER
$penFooter2 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 200, 192, 180), 1.0)
$g2.DrawLine($penFooter2, 100, 1175, $W-100, 1175)
$penFooter2.Dispose()

$g2.DrawString("MINIMALIST CAFE  |  Khong gian tinh lang, sang tao & tu do", $fontFooter2, $brushBlack2, 68, 1210)
$g2.DrawString("Mo cua: 07:00 - 22:30  |  Freeship ban kinh 3km  |  Hotline: 1900 6868", $fontSmall2, $brushBrown2, 68, 1246)
$g2.DrawString("Website: smartmenu.fnb.vn  |  Wifi: TheMinimalist_Free (Pass: cafetimeless)", $fontSmall2, $brushBrown2, 68, 1274)

# Luu anh MINIMAL
$dirMinimal = "$basePath\MINIMAL"
if (-not (Test-Path $dirMinimal)) { New-Item -ItemType Directory -Path $dirMinimal | Out-Null }
$outMinimal = "$dirMinimal\reference.png"
$bmp2.Save($outMinimal, [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host "Da luu: $outMinimal ($W x $H)"
$g2.Dispose(); $bmp2.Dispose()

# Dong resources
$brushGold2.Dispose(); $brushBlack2.Dispose(); $brushBrown2.Dispose()
$brushOrange2.Dispose(); $brushDesc2.Dispose(); $brushWhite2.Dispose()

# Dong bo sang target/classes neu ton tai
if (Test-Path $targetPath) {
    $tMinimal = "$targetPath\MINIMAL"
    $tNhietDoi = "$targetPath\NHIET_DOI"
    if (-not (Test-Path $tMinimal)) { New-Item -ItemType Directory -Path $tMinimal | Out-Null }
    if (-not (Test-Path $tNhietDoi)) { New-Item -ItemType Directory -Path $tNhietDoi | Out-Null }
    Copy-Item "$basePath\MINIMAL\reference.png" "$tMinimal\reference.png" -Force
    Copy-Item "$basePath\NHIET_DOI\reference.png" "$tNhietDoi\reference.png" -Force
    Write-Host "Da dong bo sang target/classes/menu-style"
}

Write-Host "===== HOAN TAT: Da tao thanh cong 2 mau menu moi ====="
Write-Host "  - NHIET_DOI (Tropical Fresh Bar) -> $basePath\NHIET_DOI\reference.png"
Write-Host "  - MINIMAL   (Minimalist Cafe)     -> $basePath\MINIMAL\reference.png"
