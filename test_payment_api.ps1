$ErrorActionPreference = 'Stop'
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession

# 1. Đăng ký / Đăng nhập User test
$testEmail = "payment_test_" + (Get-Random) + "@smartmenu.vn"
$regBody = @{
    fullName = "Test User Payment"
    email = $testEmail
    phone = "0988776655"
    password = "Password123!"
} | ConvertTo-Json

Write-Output "--- BƯỚC 1: ĐĂNG KÝ USER MỚI ($testEmail) ---"
$regRes = Invoke-RestMethod -Uri "http://localhost:8080/api/v1/auth/register" -Method Post -Body $regBody -ContentType "application/json" -WebSession $session
Write-Output "Register result: $($regRes | ConvertTo-Json -Depth 2)"

# Đăng nhập để lưu session cookie
$loginBody = @{
    email = $testEmail
    password = "Password123!"
} | ConvertTo-Json
$loginRes = Invoke-RestMethod -Uri "http://localhost:8080/api/v1/auth/login" -Method Post -Body $loginBody -ContentType "application/json" -WebSession $session
Write-Output "Login success. User ID: $($loginRes.data.user.id)"

# 2. Kiểm tra quyền lần đầu (Phải là FREE)
Write-Output "`n--- BƯỚC 2: CHECK ACCESS LẦN ĐẦU (KHI CHƯA DÙNG) ---"
$accessRes1 = Invoke-RestMethod -Uri "http://localhost:8080/api/v1/service/check-access" -Method Get -WebSession $session
Write-Output "Access check: $($accessRes1 | ConvertTo-Json -Depth 2)"

if ($accessRes1.data.type -ne 'FREE') {
    throw "LỖI: Lần đầu tiên phải là FREE nhưng lại nhận được $($accessRes1.data.type)"
}

# 3. Giả lập đánh dấu free_used = 1 trực tiếp trong DB để test luồng hết lượt miễn phí
Write-Output "`n--- BƯỚC 3: ĐÁNH DẤU USER ĐÃ DÙNG FREE (free_used = 1) TRONG DB ---"
$sqlScript = "UPDATE Users SET free_used = 1 WHERE email = '$testEmail';"
sqlcmd -S "localhost,1433" -U sa -P 123 -d SmartMenuDB -Q "$sqlScript"

# 4. Kiểm tra lại quyền (Phải là PAYMENT_REQUIRED)
Write-Output "`n--- BƯỚC 4: CHECK ACCESS SAU KHI HẾT FREE (PHẢI BẮT BUỘC THANH TOÁN) ---"
$accessRes2 = Invoke-RestMethod -Uri "http://localhost:8080/api/v1/service/check-access" -Method Get -WebSession $session
Write-Output "Access check: $($accessRes2 | ConvertTo-Json -Depth 2)"

if ($accessRes2.data.type -ne 'PAYMENT_REQUIRED') {
    throw "LỖI: Sau khi hết free phải là PAYMENT_REQUIRED nhưng nhận được $($accessRes2.data.type)"
}

# 5. Tạo đơn thanh toán (POST /api/v1/payment/create)
Write-Output "`n--- BƯỚC 5: TẠO GIAO DỊCH THANH TOÁN (50.000 VNĐ) ---"
$payRes = Invoke-RestMethod -Uri "http://localhost:8080/api/v1/payment/create" -Method Post -ContentType "application/json" -WebSession $session
Write-Output "Payment create: $($payRes | ConvertTo-Json -Depth 2)"
$paymentId = $payRes.data.paymentId
$txCode = $payRes.data.transactionCode
Write-Output "Payment ID: $paymentId | TxCode: $txCode | QR: $($payRes.data.qrImageUrl)"

# 6. Kiểm tra trạng thái đơn hàng (Phải là PENDING)
Write-Output "`n--- BƯỚC 6: CHECK TRẠNG THÁI PENDING ---"
$statusRes1 = Invoke-RestMethod -Uri "http://localhost:8080/api/v1/payment/check-status/$paymentId" -Method Get -WebSession $session
Write-Output "Status: $($statusRes1.data.status) | Consumed: $($statusRes1.data.consumed)"

# 7. Mock confirm thanh toán thành công (POST /api/v1/payment/mock-confirm/{id})
Write-Output "`n--- BUOC 7: XAC NHAN THANH TOAN THANH CONG (MOCK-CONFIRM) ---"
$confirmRes = Invoke-RestMethod -Uri "http://localhost:8080/api/v1/payment/mock-confirm/$paymentId" -Method Post -ContentType "application/json" -WebSession $session
Write-Output "Confirmed status: $($confirmRes.data.status)"

# 8. Check lại quyền (Bây giờ phải là PAID)
Write-Output "`n--- BƯỚC 8: CHECK ACCESS SAU KHI THANH TOÁN (PHẢI LÀ PAID) ---"
$accessRes3 = Invoke-RestMethod -Uri "http://localhost:8080/api/v1/service/check-access" -Method Get -WebSession $session
Write-Output "Access check: $($accessRes3 | ConvertTo-Json -Depth 2)"

if ($accessRes3.data.type -ne 'PAID') {
    throw "LỖI: Sau khi thanh toán thành công phải là PAID nhưng nhận được $($accessRes3.data.type)"
}

Write-Output "`n=== TAT CA CAC BUOC TEST NGHIEP VU THANH TOAN VA PHAN QUYEN DA THANH CONG ==="
