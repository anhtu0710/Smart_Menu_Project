Add-Type -AssemblyName System.Drawing

function Get-Color([string]$value) {
    [System.Drawing.ColorTranslator]::FromHtml($value)
}

function Draw-Text([System.Drawing.Graphics]$graphics, [string]$value, [float]$size, [System.Drawing.FontStyle]$style, [string]$color, [float]$x, [float]$y, [float]$width, [System.Drawing.StringAlignment]$alignment) {
    $font = [System.Drawing.Font]::new('Segoe UI', $size, $style)
    $brush = [System.Drawing.SolidBrush]::new((Get-Color $color))
    $format = [System.Drawing.StringFormat]::new()
    $format.Alignment = $alignment
    $format.LineAlignment = [System.Drawing.StringAlignment]::Center
    $graphics.DrawString($value, $font, $brush, [System.Drawing.RectangleF]::new($x, $y, $width, 26), $format)
    $format.Dispose(); $brush.Dispose(); $font.Dispose()
}

function Draw-MenuRow([System.Drawing.Graphics]$graphics, [string]$name, [string]$price, [int]$x, [int]$y, [int]$width, [string]$accent, [string]$ink) {
    $bullet = [System.Drawing.SolidBrush]::new((Get-Color $accent))
    $graphics.FillEllipse($bullet, $x, $y + 8, 7, 7)
    $bullet.Dispose()

    $leader = [System.Drawing.Pen]::new((Get-Color '#C9C9C9'), 1.4)
    $leader.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dot
    $graphics.DrawLine($leader, $x + 154, $y + 13, $x + $width - 70, $y + 13)
    $leader.Dispose()

    Draw-Text $graphics $name 13.3 ([System.Drawing.FontStyle]::Bold) $ink ($x + 15) ($y + 1) 154 ([System.Drawing.StringAlignment]::Near)
    Draw-Text $graphics $price 13.3 ([System.Drawing.FontStyle]::Bold) $accent ($x + $width - 72) ($y + 1) 72 ([System.Drawing.StringAlignment]::Far)
}

$source = 'backend\src\main\resources\menu-style\TRE_TRUNG\template_clean.png'
$destination = 'backend\src\main\resources\menu-style\TRE_TRUNG\menu-hoan-chinh.png'
$bitmap = [System.Drawing.Bitmap]::new($source)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

# Ca phe
Draw-MenuRow $graphics 'Cà phê sữa đá' '35.000đ' 323 105 294 '#D92D64' '#4A302A'
Draw-MenuRow $graphics 'Cold brew cam' '45.000đ' 323 143 294 '#D92D64' '#4A302A'
Draw-MenuRow $graphics 'Latte hạt dẻ' '52.000đ' 323 181 294 '#D92D64' '#4A302A'
Draw-MenuRow $graphics 'Mocha caramel' '55.000đ' 323 219 294 '#D92D64' '#4A302A'
Draw-MenuRow $graphics 'Bạc xỉu kem mặn' '48.000đ' 323 257 294 '#D92D64' '#4A302A'

# Tra trai cay
Draw-MenuRow $graphics 'Trà đào hoa nhài' '49.000đ' 684 105 295 '#16875B' '#31563E'
Draw-MenuRow $graphics 'Trà dâu hibiscus' '52.000đ' 684 143 295 '#16875B' '#31563E'
Draw-MenuRow $graphics 'Trà chanh mật ong' '45.000đ' 684 181 295 '#16875B' '#31563E'

# Da xay va matcha
Draw-MenuRow $graphics 'Matcha dừa' '58.000đ' 323 503 294 '#D17B17' '#714428'
Draw-MenuRow $graphics 'Cookie cream' '55.000đ' 323 541 294 '#D17B17' '#714428'
Draw-MenuRow $graphics 'Choco mint' '54.000đ' 323 579 294 '#D17B17' '#714428'

# Signature
Draw-MenuRow $graphics 'Sunrise cold brew' '59.000đ' 684 503 295 '#2463D7' '#183C73'
Draw-MenuRow $graphics 'Trà cam sữa' '62.000đ' 684 541 295 '#2463D7' '#183C73'

$bitmap.Save($destination, [System.Drawing.Imaging.ImageFormat]::Png)
$graphics.Dispose(); $bitmap.Dispose()
